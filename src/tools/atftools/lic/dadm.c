#include <Python.h>
#include <stdio.h>
#include <stdlib.h>

#include "SglW32.h"

static PyObject* py_auth_sgl(PyObject* self, PyObject* args) {

	unsigned int ReturnCode;
	unsigned int Counter0;
	unsigned int ProductId;
	unsigned int SerialNumber = 0;
	unsigned int Adr;
	unsigned int Cnt;
	unsigned int ConfigData[8];
	unsigned int Data[256];
	unsigned int DateSigned[5];
	unsigned int i;

	unsigned int AuthentCode[12] = {
            0x38F3E8C0,
            0x03601D38,
            0x1161D20C,
            0x8FA90F6E,
            0xDB870E55,
            0x0F929CBD,
            0x08364CA2,
            0x644F8C9F,
            0xCE3827B7,
            0xE7B253B0,
            0xE3D8CF9E,
            0xC5EFAADA };


    // demo auth code
    /*
			0xD72153CE,
			0xC3875391,
			0x17E0B747,
			0xD7EDC060,
			0x2F948FE4,
			0xBD401BB7,
			0x48EEEC9B,
			0xFAC755FF,
			0x2ED1399B,
			0x64BED1EE,
			0xD5D3FE7E,
			0x115172A5 };
    */

    PyArg_ParseTuple(args, "I", &ProductId);
	//printf("Id 0x%8.8X\n", ProductId);

	ReturnCode = SglAuthent(AuthentCode);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nDongle Authentication Failed (code: 0x%X)\n", ReturnCode);
		exit(-1);
	}

	// lets see whether we find a SG-Lock module ....
	ReturnCode = SglSearchLock(ProductId);
	if (ReturnCode != SGL_SUCCESS) {
		if (ReturnCode == SGL_DGL_NOT_FOUND) {
			printf("\nNo Dongle found with PRODUCT_KEY: %s\n", ProductId);
		} else {
			printf("\nDongle returned error (code: 0x%X)\n", ReturnCode);
		}
		printf("Exiting...\n");
		exit(-1);
	}

	// ... found. Ok. Lets read the serial number.
	ReturnCode = SglReadSerialNumber(ProductId, &SerialNumber);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nFailed to read Dongle (code: 0x%X)\n", ReturnCode);
		exit(-1);
	}
	return Py_BuildValue("I", SerialNumber);
}

static PyObject* py_cnt_get(PyObject* self, PyObject* args) {

	unsigned int ProductId, CounterId, Counter, ReturnCode;

    PyArg_ParseTuple(args, "II", &ProductId, &CounterId);
	//printf("Id 0x%8.8X\n", ProductId);
	//printf("Id 0x%8.8X\n", CounterId);

	ReturnCode = SglReadCounter(ProductId, CounterId, &Counter);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nSglReadCounter: Error returned! (code: 0x%X)\n", ReturnCode);
    	return Py_BuildValue("II", ReturnCode, 0);
	} else {
		//printf("Cnt %d: 0x%8.8X\n", CounterId, Counter);
    	return Py_BuildValue("II", ReturnCode, Counter);
	}
}

static PyObject* py_cnt_set(PyObject* self, PyObject* args) {

	unsigned int ProductId, CounterId, Counter, ReturnCode;

    PyArg_ParseTuple(args, "III", &ProductId, &CounterId, &Counter);

	ReturnCode = SglWriteCounter(ProductId, CounterId, Counter);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nSglWriteCounter: Error returned! (code: 0x%X)\n", ReturnCode);
	}
  	return Py_BuildValue("I", ReturnCode);
}

static PyObject* py_data_get_uint(PyObject* self, PyObject* args) {

	unsigned int ProductId, DataId, Data, ReturnCode;

    PyArg_ParseTuple(args, "II", &ProductId, &DataId);

	ReturnCode = SglReadData(ProductId, DataId, 1, &Data);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nSglReadCounter: Error returned! (code: 0x%X)\n", ReturnCode);
    	return Py_BuildValue("II", ReturnCode, 0);
	} else {
    	return Py_BuildValue("II", ReturnCode, Data);
	}
}

static PyObject* py_data_set_uint(PyObject* self, PyObject* args) {

	unsigned int ProductId, DataId, Data, ReturnCode;

    PyArg_ParseTuple(args, "III", &ProductId, &DataId, &Data);

	ReturnCode = SglWriteData(ProductId, DataId, 1, &Data);
	if (ReturnCode != SGL_SUCCESS) {
		printf("\nSglWriteData: Error returned! (code: 0x%X)\n", ReturnCode);
	}
   	return Py_BuildValue("I", ReturnCode);
}

/*
 * Bind Python function names to C functions.
 */
static PyMethodDef dongle_methods[] = { 
	{ "auth_sgl", py_auth_sgl, METH_VARARGS },
	{ "cnt_get", py_cnt_get, METH_VARARGS },
	{ "cnt_set", py_cnt_set, METH_VARARGS },
	{ "data_get_uint", py_data_get_uint, METH_VARARGS },
	{ "data_set_uint", py_data_set_uint, METH_VARARGS },
	{ NULL, NULL }
};

/*
 * Python calls this to initialize our module.
 */
void initdadm() {
	(void) Py_InitModule("dadm", dongle_methods);
}

// static constructor
/*
__attribute__((constructor)) static void _dongle() {

	unsigned int ReturnCode;
	unsigned int Counter0;
	unsigned int ProductId;
	unsigned int SerialNumber;
	unsigned int Adr;
	unsigned int Cnt;
	unsigned int ConfigData[8];
	unsigned int Data[256];
	unsigned int DateSigned[5];
	unsigned int i;

	unsigned int AuthentCode[12] = {   // replace with your auth.code
			0xD72153CE, 0xC3875391, 0x17E0B747, 0xD7EDC060, 0x2F948FE4,
					0xBD401BB7, 0x48EEEC9B, 0xFAC755FF, 0x2ED1399B, 0x64BED1EE,
					0xD5D3FE7E, 0x115172A5 };

	ProductId = 0x0001; // 16-bit value, that can be used to give different porducts
	// of a company different IDs, which makes it easier to
	// distinguish between theese products.

	printf("\nSG-Lock program.\n");
	printf("Searching SG-Lock with ProductId %d ...\n", ProductId);

	// first we authenticate us (the application) to the library and vice versa)
	// this has to be done once BEFORE using other functions of the API in the case
	// that the library is loaded statically. In the case you load the library dynamically
	// ( Windows LoadLibrary function) you have to do it every time after loading
	ReturnCode = SglAuthent(AuthentCode);
	if (ReturnCode != SGL_SUCCESS) {
		printf("SglAuthent: Error returned! (code: 0x%X)\n", ReturnCode);
		return;
	}

	// lets see whether we find a SG-Lock module ....
	ReturnCode = SglSearchLock(ProductId);
	if (ReturnCode != SGL_SUCCESS) {
		if (ReturnCode == SGL_DGL_NOT_FOUND) {
			printf("No SG-Lock found!\n");
			printf("Please Plug SG-Lock in and run again!\n");

		} else {
			printf("SglSearchLock: Error returned! (code: 0x%X)\n", ReturnCode);
		}
		exit(-1);
		// return;
	}

	printf("SG-Lock found!\n");

	// ... found. Ok. Lets read the serial number.
	ReturnCode = SglReadSerialNumber(ProductId, &SerialNumber);
	if (ReturnCode != SGL_SUCCESS) {
		printf("SglReadSerialNumber: Error returned! (code: 0x%X)\n",
				ReturnCode);
		return;
	} else {
		printf("SG-Lock serial number: %d\n", SerialNumber);
	}

	// read SG-Lock informations }

	ReturnCode = SglReadConfig(ProductId, SGL_READ_CONFIG_LOCK_INFO,
			ConfigData);

	if (ReturnCode == SGL_SUCCESS) {
		if (ConfigData[1] == SGL_CONFIG_INTERFACE_USB) {
			printf("SG-Lock type: U%d\n", ConfigData[0] + 1);
		} else {
			printf("SG-Lock type: L%d\n", ConfigData[0] + 1);
		}
	} else {
		printf("SglReadConfig: error: %d\n", ReturnCode);
	}

	// check if we have memory and counters U3/U4/L3/L4 and NOT U2/L2 }
	if (ConfigData[0] != 1) {

		// Lets read some data ...
		Adr = 0; // read from start of memory
		Cnt = 4; // 4 DWORDs

		// theese functions are not supported by the 2 series - only 3 and 4 series
		ReturnCode = SglReadData(ProductId, Adr, Cnt, Data);
		if (ReturnCode != SGL_SUCCESS) {
			printf("SglReadData: Error returned! (code: 0x%X)\n", ReturnCode);
			return;
		} else {
			printf("SG-Lock data read:\n");
			for (i = 0; i < Cnt; i++) {
				printf("Adr %d: 0x%8.8X\n", Adr + i, Data[i]);
			}
		}

		printf("SG-Lock counter read:\n");
		for (i = 0; i < 4; i++) {

			ReturnCode = SglReadCounter(ProductId, i, Data);
			if (ReturnCode != SGL_SUCCESS) {
				printf("SglReadCounter: Error returned! (code: 0x%X)\n",
						ReturnCode);
				return;
			} else {
				printf("Cnt %d: 0x%8.8X\n", i, Data[0]);
				if (i == 0) {
					Counter0 = Data[0];
					// SglWriteCounter(ProductId, 0, Counter0 + 1);
				}
			}
		}
	}

	// Let's sign some data. We use a common date with day/month/year and store also
	// the 64-bit signature n the data field.
	DateSigned[0] = 31;
	DateSigned[1] = 12;
	DateSigned[2] = 2005;

	printf("SG-Lock signing functions:\n");

	ReturnCode = SglSignDataLock(ProductId, 0, SGL_SIGNATURE_GENERATE,
			(sizeof(DateSigned) / 4) - 2, DateSigned, &DateSigned[3]);

	if (ReturnCode != SGL_SUCCESS) {
		if (ReturnCode == SGL_DGL_NOT_FOUND) {
			printf("SG-Lock not found!\n");
		} else {
			printf("SglSearchLock: Error returned! (code: 0x%X)\n", ReturnCode);
			return;
		}
	}

	printf("Signing date %d %d %d, signature is: 0x%8.8X 0x%8.8X\n",
			DateSigned[0], DateSigned[1], DateSigned[2], DateSigned[3],
			DateSigned[4]);

	// Uncomment the next line to simulate data manipulation
	// DateSigned[0]= 30;
	printf("Verifing signature ... ");
	ReturnCode = SglSignDataLock(ProductId, 0, SGL_SIGNATURE_VERIFY,
			(sizeof(DateSigned) / 4) - 2, DateSigned, &DateSigned[3]);

	switch (ReturnCode) {
	case SGL_SUCCESS:
		printf("Date valid!\n");
		break;
	case SGL_SIGNATURE_INVALID:
		printf("Date INVALID!\n");
		break;
	case SGL_DGL_NOT_FOUND:
		printf("SG-Lock not found!\n");
		return;
	default:
		printf("SglSearchLock: Error returned! (code: 0x%X)\n", ReturnCode);

	}

}
*/