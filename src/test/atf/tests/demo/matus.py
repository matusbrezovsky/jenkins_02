def get_pid(pid):
    pid = str(pid)
    result = [str(s) for s in pid.split() if s.isdigit()]
    return result[0]

def is_running(all_pids, pid):
    all_pids = str(all_pids)
    pid = str(pid)

    if all_pids.find(pid) != -1:
        return '0'
    else:
        return '-1'
