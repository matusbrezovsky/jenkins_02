# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atf.utils.utils import Utils
from robot.output import LOGGER

#class UtilsWrapper(Utils):
class UtilsWrapper():


    def __init__(self):
        # comment this block for API doc generation:
        # CUDO_BLOCK_START
        LOGGER.info('ATF initiate: ATFCommons binary library')
        self._w = Utils()
        LOGGER.info('ATF initiate: OK')
        # CUDO_BLOCK_END
        pass


    def get_as_list(self, obj, ret_dict_keys=True, separator=None, trim_re=None):
        """
        Converts different types of variable into List
        Currently supported conversions:
        1) scalar to list
        2) list to list
        3) dictionary to list (returns dictionary keys)
        4) string with separators --> list of strings (without the separator characters)

        -  obj:             Dictionary, List or Scalar (unicode, str or int)
        -  ret_dict_keys:   return dictionary keys or values as list (valid only with type 3) conversion)
        -  separator:       character(s) to use as separator when splitting string with type 4) conversion.
                            If "None" no splitting will be done.
        -  trim_re:         the matching regular expression will be removed from the obj before the conversion (valid when obj is string).

        returns:         List
        """
        return self._w.get_as_list(obj, ret_dict_keys, separator, trim_re)

    def check_if_exists_and_return_type(self, obj, ignore_empty=False):
        """
        Checks if the variable is set and return type (Scalar, List or Dict).

        Return True if set and the variable type "Scalar/List/Dict"
        Return False if the value equals ${None} or ${null}
        Return False if the ignoreempty=False and the value equals ${EMPTY}

        -  obj:             Dictionary, List or Scalar (unicode, str or int)
        -  ignore_empty:     How to treat empty (='') value

        returns:                 List with two items [0]: Exists Check result (boolean), [1]: Type as String ('Dict', 'List' or 'Scalar')
        """
        return self._w.check_if_exists_and_return_type(obj, ignore_empty)

    def check_if_exists(self, obj, ignore_empty=False):
        """
        Checks if the variable is set.

        As `Check If Exists and Return Type` but returns only the existence check result.
        -  obj:             see `Check If Exists and Return Type`
        -  ignore_empty:     see `Check If Exists and Return Type`

        returns:                 see `Check If Exists and Return Type`
        """
        return self._w.check_if_exists(obj, ignore_empty)

    ################################################################################################################################################
    #
    #   #######  #     #  #######      ######   #######   #####   #######  #     #  ######
    #      #      #   #      #         #     #  #        #     #  #         #   #   #     #
    #      #       # #       #         #     #  #        #        #          # #    #     #
    #      #        #        #         ######   #####    #  ####  #####       #     ######
    #      #       # #       #         #   #    #        #     #  #          # #    #
    #      #      #   #      #         #    #   #        #     #  #         #   #   #
    #      #     #     #     #         #     #  #######   #####   #######  #     #  #
    #
    ################################################################################################################################################
    def text_should_not_match_any_regex(self, txt, list_of_res, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text contains at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions.

        Each RE in the list is tested against the text.
        Fails if one of the RE's match.

        -  txt: The string to match (can be single or multi-line text)
        -  list_of_res: List of Regular Expressions that should match the String
        -  re_prefix: Pre-fix to add to each RE, default ".*"
        -  re_postfix: Post-fix to add to each RE, default ".*"
        -  fail_on_error: Should we fail on error or simply return False.
        -  err_msg: Error message to print on failure. Meaningless if fail_on_error=False


        returns:  True if none of the REs matched, otherwise False. Valid only with fail_on_error=False
        """
        return self._w.text_should_not_match_any_regex(txt, list_of_res, re_prefix, re_postfix, fail_on_error, err_msg)

    def text_should_match_number_of_regex(self, txt, match_count, list_of_res, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text contains at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions.

        Each RE in the list is tested against the text.
        Fails if the RE's match count is not as expected

        -  txt: The string to match (can be single or multi-line text)
        -  list_of_res: List of Regular Expressions that should match the String
        -  re_prefix: Pre-fix to add to each RE, default ".*"
        -  re_postfix: Post-fix to add to each RE, default ".*"
        -  fail_on_error: Should we fail on error or simply return False.
        -  err_msg: Error message to print on failure. Meaningless if fail_on_error=False

        returns:  True if the correct number of REs matched, otherwise False. Valid only with fail_on_error=False
        """
        return self._w.text_should_match_number_of_regex(txt, match_count, list_of_res, re_prefix, re_postfix, fail_on_error, err_msg)

    def text_should_match_at_least_one_regex(self, txt, list_of_res, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text didn't contain at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions.

        Each RE in the list is tested against the text.
        Fails if none the RE's fail to match.

        -  txt: The string to match (can be single or multi-line text)
        -  list_of_res: List of Regular Expressions that should match the String
        -  re_prefix: Pre-fix to add to each RE, default ".*"
        -  re_postfix: Post-fix to add to each RE, default ".*"
        -  fail_on_error: Should we fail on error or simply return False.
        -  err_msg: Error message to print on failure. Meaningless if fail_on_error=False

        returns:  True if one of the REs matched, otherwise False. Valid only with fail_on_error=False
        """
        return self._w.text_should_match_at_least_one_regex(txt, list_of_res, re_prefix, re_postfix, fail_on_error, err_msg)

    def text_should_match_all_regex(self, txt, list_of_res, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text didn't contain all RegEx"):
        """
        Verify a string with a list of Regular Expressions.

        Each RE in the list is tested against the text.
        Fails if one the RE's fail to match.

        -  txt: The string to match (can be single or multi-line text)
        -  list_of_res: List of Regular Expressions that should match the String
        -  re_prefix: Pre-fix to add to each RE, default ".*"
        -  re_postfix: Post-fix to add to each RE, default ".*"
        -  fail_on_error: Should we fail on error or simply return False.
        -  err_msg: Error message to print on failure. Meaningless if fail_on_error=False

        returns:  True if all REs matched, otherwise False. Valid only with fail_on_error=False
        """
        return self._w.text_should_match_all_regex(txt, list_of_res, re_prefix, re_postfix, fail_on_error, err_msg)

    ################################################################################################################################################
    #
    #   #######  #     #  #######     #        ###   #####   #######     ######   #######   #####   #######  #     #  ######
    #      #      #   #      #        #         #   #     #     #        #     #  #        #     #  #         #   #   #     #
    #      #       # #       #        #         #   #           #        #     #  #        #        #          # #    #     #
    #      #        #        #        #         #    #####      #        ######   #####    #  ####  #####       #     ######
    #      #       # #       #        #         #         #     #        #   #    #        #     #  #          # #    #
    #      #      #   #      #        #         #   #     #     #        #    #   #        #     #  #         #   #   #
    #      #     #     #     #        #######  ###   #####      #        #     #  #######   #####   #######  #     #  #
    #
    ################################################################################################################################################
    def any_text_item_in_list_should_contain_all_regex(self, list_of_txt_items, list_of_res, re_prefix='.*', re_postfix='.*', start_at=0, fail_on_error=True, err_msg="Text Item List validation failed"):
        """
        Verify a list of strings with a list of Regular Expressions.

        Each RE in the RE list is tested against each item in the text list.
        Fails if none of the items in the String List matches all of the RE's.

        -  list_of_txt_items: The list of strings to match (can be single or multi-line text)
        -  list_of_res:       List of Regular Expressions that should matched against the Strings
        -  re_prefix:         Pre-fix to add to each RE, default ".*"
        -  re_postfix:        Post-fix to add to each RE, default ".*"
        -  start_at:          Index where to start the search
        -  fail_on_error:     Should we fail on error or simply return False.
        -  err_msg:           Error message to print on failure. Meaningless if fail_on_error=False

        returns:                  Index of the matched entry. Valid only with fail_on_error=False: -1 if no match found.
        """
        return self._w.any_text_item_in_list_should_contain_all_regex(list_of_txt_items, list_of_res, re_prefix, re_postfix, start_at, fail_on_error, err_msg)


    #   #     #     #     #######   #####   #     #     ######   #######  #######  ######   #     #     #         #####   #######
    #   ##   ##    # #       #     #     #  #     #     #     #     #        #     #     #  ##    #     #        #     #     #
    #   # # # #   #   #      #     #        #     #     #     #     #        #     #     #  # #   #     #        #           #
    #   #  #  #  #     #     #     #        #######     ######      #        #     ######   #  #  #     #         #####      #
    #   #     #  #######     #     #        #     #     #           #        #     #   #    #   # #     #              #     #
    #   #     #  #     #     #     #     #  #     #     #           #        #     #    #   #    ##     #        #     #     #
    #   #     #  #     #     #      #####   #     #     #           #        #     #     #  #     #     #######   #####      #
    def pattern_list_should_match(self, input_txt, match_obj, threshold=80, regex=False, reverse_match=False):
        """
        Verify a text string with a list of patterns.
        """
        return self._w.pattern_list_should_match(input_txt, match_obj, threshold=threshold, regex=regex, reverse_match=reverse_match)

    ################################################################################################################################################
    #
    #       ######   ###     #     #        #######   #####    #####
    #       #     #   #     # #    #        #     #  #     #  #     #
    #       #     #   #    #   #   #        #     #  #        #
    #       #     #   #   #     #  #        #     #  #  ####   #####
    #       #     #   #   #######  #        #     #  #     #        #
    #       #     #   #   #     #  #        #     #  #     #  #     #
    #       ######   ###  #     #  #######  #######   #####    #####
    #
    ################################################################################################################################################
    def prepare_manual_step(self, dlg_txt, skip_msg='Skipping Manual Steps'):
        """
        Show a dialog before entering manual steps.

        Display a warning dialog about upcoming manual steps, i.e. the user should acknowledge that he/she is ready for
        the upcoming manual steps.
        With this dialog the manual test cases can also be executed without continuous attendance. For example when you
        show this dialog before starting the traces the test case can be started and while it's running the set-up steps
        you can focus on something else (your emails, go for lunch or whatever).
        Without this step the traces would be started and the dialog for the actual manual step
        (e.g. "trigger a Location Update") would wait for the response from the user, who has gone for lunch
        --> The trace files would become huge.
        The manual steps can be skipped by setting the global variable DLGS_SKIP to True.

        -  dlg_txt:     The text to be displayed in the dialog.
        -  skip_msg:    The Message to print when skipping this step.

        returns:             None
        """
        self._w.prepare_manual_step(dlg_txt, skip_msg)

    def pause_for_manual_step(self, dlg_txt, fail_on_skip=None, skip_msg='Skipping Manual Steps'):
        """
        Pause for manual steps without verification.

        Use this to pause for manual steps that don't need verification of the results. For example when triggering a
        handover with the Attenuation box/switching cables.
        The manual steps can be skipped by setting the global variable DLGS_SKIP to True.
        The default behaviour (FAIL/PASS) when skipping this dialog can be set with global variable DLGS_FAIL_ON_SKIP.

        -  dlg_txt:         The text to be displayed in the dialog.
        -  fail_on_skip:    Should we fail if the Manual Steps are skipped.
        -  skip_msg:        The Message to print when skipping this step.

        returns:                 None
        """
        self._w.pause_for_manual_step(dlg_txt, fail_on_skip, skip_msg)

    def evaluate_manual_step(self, dlg_txt, err_txt, sleep_time=None, fail_on_skip=None,
                             skip_msg='Skipping Manual Steps'):
        """
        Pause for manual steps with verification.

        Use this to pause for manual steps that verification of the results. For example when calling Voicemail and expecting certain annoucement/prompt from the VMS menu.
        The manual steps can be skipped by setting the global variable DLGS_SKIP to True.
        The default sleep_time, i.e. how long to wait before proceeding when the dialogs are skipped (e.g. DLGS_SKIP=True).
        The default behaviour (FAIL/PASS) when skipping this dialog can be set with global variable DLGS_FAIL_ON_SKIP.

        -  dlg_txt:         The text to be displayed in the dialog.
        -  err_txt:         The error text to show if the test fails.
        -  sleep_time:      How long should we sleep the manual steps are skipped (i.e. DLGS_SKIP=True).
        -  fail_on_skip:    Should we fail if the Manual Steps are skipped.
        -  skip_msg:        The Message to print when skipping this step.

        returns:                 None
        """
        self._w.evaluate_manual_step(dlg_txt, err_txt, sleep_time, fail_on_skip, skip_msg)

    ################################################################################################################################################
    #
    #   ######   ######    #####      #        #######   #####
    #   #     #  #     #  #     #     #        #     #  #     #
    #   #     #  #     #  #           #        #     #  #
    #   #     #  ######   #  ####     #        #     #  #  ####
    #   #     #  #     #  #     #     #        #     #  #     #
    #   #     #  #     #  #     #     #        #     #  #     #
    #   ######   ######    #####      #######  #######   #####
    #
    ################################################################################################################################################
    def debug_log_xml(self, logelement, debug_log=None, debug_level=None):
        """
        Helper function to log XML elements.

        See `Debug Log` (mode=xml) for more details
        """
        return self._w.debug_log_xml(logelement, debug_log, debug_level)

    def debug_log(self, logelement, debug_log=None, debug_level=None, mode='txt'):
        """
        Print debug logs into the execution log or to the console.

        Global variables DBG_LOG (True/False) controls the debug log status (On/Off) and DBG_LEVEL controls the log level (e.g. INFO/WARN).
        The global variables can be overridden with the method arguments.

        -  logelement: The text to be logged (with mode=txt, default) or the XML-element (with mode=xml)
        -  debug_log: Enable log (True/False). Intended to override the global one i.e. DBG_LOG=False + debug_log=True --> debug log is printed.
        -  debug_level: The log level to be used. DEBUG/INFO prints into the log file, WARN prints to the console
        -  mode: Log mode, "txt" or "xml". The "xml" mode enables human readable logs of XML elements

        returns:   True if the log was written, otherwise False
        """
        return self._w.debug_log(logelement, debug_log, debug_level, mode)

    ################################################################################################################################################
    #
    #   #######  #     #  #######   #####           #####   #######  ######   #
    #   #         #   #   #        #     #         #     #     #     #     #  #
    #   #          # #    #        #               #           #     #     #  #
    #   #####       #     #####    #               #           #     ######   #
    #   #          # #    #        #               #           #     #   #    #
    #   #         #   #   #        #     #         #     #     #     #    #   #
    #   #######  #     #  #######   #####           #####      #     #     #  #######
    #
    ################################################################################################################################################
    def skip_test_step(self, skip_step_var, log_msg):
        return self._w.skip_test_step(skip_step_var, log_msg)

    def create_results_directory(self):
        """
        Create local directories for the logs and traces.

        Creates the results directory for the later steps that'll download the traces and SPML logs into this directory.
        The directory name depends on the execution mode (i.e. the value of the DEVELOPMENT_MODE global variable)
        If the DEVELOPMENT_MODE=True then the directory will be "./results/last" (NOTE: results in this directory will be overwritten)
        If the DEVELOPMENT_MODE=False then the directory will be "./results/<timestamp>_<test suite name>"

        returns:     String containing the full path to the generated directory
        """
        return self._w.create_results_directory()

    ################################################################################################################################################
    #  P R I V A T E
    ################################################################################################################################################
    def _skip_test_step(self, skip_step_var, log_msg):
        return self._w._skip_test_step(skip_step_var, log_msg)

    def _skip_suite_step(self, skip_step_var, log_msg):
        return self._w._skip_suite_step(skip_step_var, log_msg)

    def _skip_global_step(self, skip_step_var, log_msg):
        return self._w._skip_global_step(skip_step_var, log_msg)

    def _in_dummy_mode(self, log_msg, scope='Suite'):
        return self._w._in_dummy_mode(log_msg, scope)


    ################################################################################################################################################
    ######   #######  ######   ######   #######   #####      #     #######  #######  ######
    #     #  #        #     #  #     #  #        #     #    # #       #     #        #     #
    #     #  #        #     #  #     #  #        #         #   #      #     #        #     #
    #     #  #####    ######   ######   #####    #        #     #     #     #####    #     #
    #     #  #        #        #   #    #        #        #######     #     #        #     #
    #     #  #        #        #    #   #        #     #  #     #     #     #        #     #
    ######   #######  #        #     #  #######   #####   #     #     #     #######  ######
    #############################################################################################################################################

    #############################################################################################################################################
    #######  #     #  ######   ###  ######   #######  ######
    #         #   #   #     #   #   #     #  #        #     #
    #          # #    #     #   #   #     #  #        #     #
    #####       #     ######    #   ######   #####    #     #
    #          # #    #         #   #   #    #        #     #
    #         #   #   #         #   #    #   #        #     #
    #######  #     #  #        ###  #     #  #######  ######
    #############################################################################################################################################
    def return_empty_unless(self, condition, return_if_true):
        self._w.return_empty_unless(condition, return_if_true)

    def set_variable_if_else(self, condition, return_if_true, return_if_false):
        self._w.set_variable_if_else(condition, return_if_true, return_if_false)
