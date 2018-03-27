
select user_tasks.choice, tasks.folder, tasks.selected_time_stamp from user_tasks, tasks where user_tasks.user_tasks_id = tasks.choice;