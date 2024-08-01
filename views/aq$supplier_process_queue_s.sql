--
-- View "AQ$SUPPLIER_PROCESS_QUEUE_S"
--
CREATE OR REPLACE FORCE EDITIONABLE VIEW "XX_TANGO"."AQ$SUPPLIER_PROCESS_QUEUE_S" ("NAME", "ADDRESS", "PROTOCOL", "TRANSFORMATION", "QUEUE_TO_QUEUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  consumer_name NAME ,  address ADDRESS ,  protocol PROTOCOL,  transformation TRANSFORMATION,  queue_to_queue QUEUE_TO_QUEUE  FROM  all_queue_subscribers s WHERE s.owner = 'XX_TANGO' AND   s.queue_name = 'SUPPLIER_PROCESS_QUEUE' WITH READ ONLY
/