--
-- View "AQ$PM_TEQ_JSON_QUEUE1"
--
CREATE OR REPLACE FORCE EDITIONABLE VIEW "XX_TANGO"."AQ$PM_TEQ_JSON_QUEUE1" ("QUEUE", "MSG_ID", "CORR_ID", "MSG_PRIORITY", "MSG_STATE", "DELAY", "DELAY_TIMESTAMP", "EXPIRATION", "ENQ_TIME", "ENQ_TIMESTAMP", "ENQ_USER_ID", "ENQ_TXN_ID", "DEQ_TIME", "DEQ_TIMESTAMP", "DEQ_USER_ID", "DEQ_TXN_ID", "RETRY_COUNT", "EXCEPTION_QUEUE_OWNER", "EXCEPTION_QUEUE", "USER_DATA", "PROPAGATED_MSGID", "SENDER_NAME", "SENDER_ADDRESS", "SENDER_PROTOCOL", "ORIGINAL_MSGID", "ORIGINAL_QUEUE_NAME", "ORIGINAL_QUEUE_OWNER", "EXPIRATION_REASON", "CONSUMER_NAME", "ADDRESS", "PROTOCOL") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with msgbm as  (select 'PM_TEQ_JSON_QUEUE1' QUEUE_NAME, qt_mc.msgid MSGID, qt_mc.correlation CORRELATION, qt_mc.priority PRIORITY, qt_mc.state STATE, qt_mc.delivery_time DELIVERY_TIME, qt_mc.expiration EXPIRATION,  qt_mc.enq_time ENQ_TIME, qt_mc.bitmap SBITMAP,  qt_mc.lck_bitmap LCK_BITMAP  from TABLE(AQ$_GET_CACHE_MSGBM(98206))  qt_mc where qt_mc.state NOT IN (0, 1, 2, 128, 192 ))  SELECT  qs.NAME QUEUE, qt.msgid MSG_ID, qt.CORRELATION CORR_ID, qt.priority MSG_PRIORITY,  case  
        when qt_l.flags is NULL then 
          (case  
             when qt.subshard < l.lwm  then 'PROCESSED' 
             else  
               (case
                  when qt.mc_state is NULL OR qt.mc_state = 3 then
                    (case
                       when qt.state = 7 then 'EXPIRED'
                       else
                         (case 
                            when (qt.DELIVERY_TIME IS NOT NULL) then 
                              (case 
                                 when 
                                   ((systimestamp - qt.DELIVERY_TIME) > 
                                      (INTERVAL '0 0:0:0.0' DAY TO SECOND)) 
                                           then 'READY' 
                                 else 'WAIT' 
                               end) 
                            else 'READY'
                          end)
                     end)
                  else
                    (case qt.mc_state
                       when 4 then 'LOCKED'
                       when 5 then 'RETRYEXPIRED'
                       when 6 then 'PROCESSED'
                       when 7 then 'EXPIRED'
                       when 8 then 'PROCESSED'
                       when 9 then 'READY'
                       when 10 then 'EXPIRED'
                     end)
                end) 
           end) 
        else
          (case mod(qt_l.flags-1 , 7) 
             when 0 then 'PROCESSED'
             when 1 then 'UNDELIVERABLE'
             when 2 then 'PROCESSED'
             when 5 then 'RETRYEXPIRED'
             else 
               (case 
                  when qt.state =7 then 'EXPIRED'
                  else
                    (case mod(qt_l.flags-1 , 7)
                       when 3 then 'READY'
                       when 4 then 'ROLBACKREADY'
                       when 6 then 'DISCARDED'
                       when 0-1 then 'READY'
                     end)
                end)
           end)
      end MSG_STATE,  cast(qt.delivery_time at time zone       sessiontimezone as date) DELAY,  cast(qt.delivery_time at time zone       sessiontimezone as timestamp) DELAY_TIMESTAMP,  qt.expiration EXPIRATION,  cast(qt.ENQUEUE_TIME at time zone       sessiontimezone as date) ENQ_TIME,  cast(qt.ENQUEUE_TIME at time zone        sessiontimezone as timestamp) ENQ_TIMESTAMP,  NULL ENQ_USER_ID,  NULL ENQ_TXN_ID,  decode(qt_l.transaction_id, NULL, TO_DATE(NULL),         cast(qt_l.DEQUEUE_TIME at time zone sessiontimezone             as date)) DEQ_TIME,  decode(qt_l.transaction_id, NULL, TO_TIMESTAMP(NULL),         cast(qt_l.DEQUEUE_TIME at time zone sessiontimezone        as timestamp)) DEQ_TIMESTAMP,  qt_l.DEQUEUE_USER DEQ_USER_ID,  qt_l.TRANSACTION_ID DEQ_TXN_ID,  qt_l.retry_count RETRY_COUNT,  NULL EXCEPTION_QUEUE_OWNER,  qt.exception_queue EXCEPTION_QUEUE,  qt.USER_DATA USER_DATA,  NULL PROPAGATED_MSGID,  NULL SENDER_NAME,  NULL SENDER_ADDRESS,  NULL SENDER_PROTOCOL,  qt.old_msgid ORIGINAL_MSGID,  NULL ORIGINAL_QUEUE_NAME,  NULL ORIGINAL_QUEUE_OWNER,  NULL EXPIRATION_REASON,  NULL CONSUMER_NAME,  NULL ADDRESS,  NULL PROTOCOL   FROM  (select  qt_mc.queue_name,  qt.shard,  qt.subshard,  case when qt.MSGID is null then qt_mc.msgid  else qt.MSGID end msgid,  case when qt.CORRELATION is null then qt_mc.correlation else qt.CORRELATION end correlation,  case when qt.PRIORITY is null then qt_mc.priority  else qt.PRIORITY end priority,  case when qt.STATE is null  then (qt_mc.state)  else (case when qt.state=3 then 7 else qt.STATE end)  end state,  qt.state QT_STATE, qt_mc.state MC_STATE, case when qt.DELIVERY_TIME is null then  qt_mc.delivery_time else qt.DELIVERY_TIME  end delivery_time,  case when qt.EXPIRATION is null then qt_mc.expiration  else qt.EXPIRATION end expiration,  case when qt.ENQUEUE_TIME is null then qt_mc.enq_time  else qt.ENQUEUE_TIME end ENQUEUE_TIME,  qt.old_msgid old_msgid,  qt.exception_queue exception_queue,  USER_DATA,  qt.subscriber_map qt_sbitmap,                           case when qt.SUBSCRIBER_MAP is null then qt_mc.sbitmap       else qt.SUBSCRIBER_MAP end sbitmap, qt_mc.LCK_BITMAP lbitmap from "PM_TEQ_JSON_QUEUE1" qt  FULL OUTER JOIN  msgbm qt_mc  ON (qt.msgid = qt_mc.msgid)) qt  LEFT OUTER JOIN (SELECT queue_id, base_queue_id, name, shard_id,   delay_shard_id FROM all_queue_shards WHERE       (queue_id = 98206 OR    base_queue_id = 98206)) qs  ON 
          (qt.shard = qs.shard_id OR 
           qt.shard = qs.delay_shard_id) 
        LEFT OUTER JOIN "_ALL_TXEVENTQ_SUB_LWMS" l ON 
          (l.QUEUE_ID = 98206 AND
           l.shard_id   = qt.shard AND
           l.priority = qt.priority AND 
           l.subscriber_id = 0)
        LEFT OUTER JOIN "AQ$_PM_TEQ_JSON_QUEUE1_L" qt_l ON (qt.msgid = qt_l.msgid)   WITH READ ONLY
/