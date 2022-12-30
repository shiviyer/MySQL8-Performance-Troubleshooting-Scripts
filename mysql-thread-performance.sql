select
    t.THREAD_ID as Thread_ID,
    t.PARENT_THREAD_ID as Parent_Thread_ID,
    t.PROCESSLIST_DB as Default_Database,
    SUBSTRING(esc.SQL_TEXT,1,65) as SQL_Text,
    sys.format_time(esc.TIMER_START) as Timer_Start,
    sys.format_time(esc.TIMER_END) as Timer_End,
    t.TOTAL_MEMORY as Total_Memory,
    esc.CPU_TIME as Time_Spent_on_CPU_for_current_thread,
    esc.ROWS_EXAMINED as Total_Rows_Examined,
    esc.ROWS_SENT as Total_Rows_Sent,
    (esc.ROWS_EXAMINED/esc.ROWS_SENT) as Cost_To_Data_Access,
    etc.STATE as Curent_State,
    etc.ISOLATION_LEVEL as Transaction_Isolation_Level,
    etc.ACCESS_MODE as Access_Mode,
    sys.format_time(esc.LOCK_TIME) as Time_Spent_Waiting_for_Table_Locks,
    ewc.SPINS as number_of_spin_round_for_a_Mutex,
    dl.LOCK_STATUS as Lock_Status,
    dl.LOCK_DATA as "Data_Locked",
    dl.LOCK_MODE as Lock_Mode
from performance_schema.threads t
join events_statements_current esc on t.THREAD_ID = esc.THREAD_ID
join events_stages_current e on t.THREAD_ID = e.THREAD_ID
join events_transactions_current etc on e.THREAD_ID = etc.THREAD_ID
join events_waits_current ewc on e.THREAD_ID = ewc.THREAD_ID
left join data_locks dl on esc.THREAD_ID = dl.THREAD_ID
left outer join status_by_thread sbt on dl.THREAD_ID = sbt.THREAD_ID
where t.PROCESSLIST_STATE!=null;
