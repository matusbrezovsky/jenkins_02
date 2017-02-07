@echo off
call update_version.cmd
call compile2.cmd
call generate_API_doc.cmd
call make_dist.cmd
