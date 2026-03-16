CLASS zcl_emu_22it115 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_meter_hdr,
             meterid TYPE zem_de_meterid,
           END OF ty_meter_hdr,
           BEGIN OF ty_meter_itm,
             meterid   TYPE zem_de_meterid,
             readingno TYPE int2,
           END OF ty_meter_itm.
    TYPES: tt_meter_hdr TYPE STANDARD TABLE OF ty_meter_hdr,
           tt_meter_itm TYPE STANDARD TABLE OF ty_meter_itm.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_emu_22it115.

    METHODS:
      set_hdr_value IMPORTING im_meter_hdr TYPE zem_hdr_22it115
                    EXPORTING ex_created   TYPE abap_boolean,
      get_hdr_value EXPORTING ex_meter_hdr TYPE zem_hdr_22it115,
      set_itm_value IMPORTING im_meter_itm TYPE zem_itm_22it115
                    EXPORTING ex_created   TYPE abap_boolean,
      get_itm_value EXPORTING ex_meter_itm TYPE zem_itm_22it115,
      set_hdr_t_deletion IMPORTING im_meter_doc  TYPE ty_meter_hdr,
      set_itm_t_deletion IMPORTING im_meter_info TYPE ty_meter_itm,
      get_hdr_t_deletion EXPORTING ex_meter_docs TYPE tt_meter_hdr,
      get_itm_t_deletion EXPORTING ex_meter_info TYPE tt_meter_itm,
      set_hdr_deletion_flag IMPORTING im_del     TYPE abap_boolean,
      get_deletion_flags    EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gs_hdr_buff  TYPE zem_hdr_22it115,
                gs_itm_buff  TYPE zem_itm_22it115,
                gt_hdr_t_del TYPE tt_meter_hdr,
                gt_itm_t_del TYPE tt_meter_itm,
                gv_hdr_del   TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_emu_22it115.
ENDCLASS.

CLASS zcl_emu_22it115 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_meter_hdr-meterid IS NOT INITIAL.
      gs_hdr_buff = im_meter_hdr.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_meter_hdr = gs_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_meter_itm IS NOT INITIAL.
      gs_itm_buff = im_meter_itm.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_meter_itm = gs_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_meter_doc TO gt_hdr_t_del.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_meter_info TO gt_itm_t_del.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    ex_meter_docs = gt_hdr_t_del.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    ex_meter_info = gt_itm_t_del.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    gv_hdr_del = im_del.
  ENDMETHOD.

  METHOD get_deletion_flags.
    ex_hdr_del = gv_hdr_del.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr_buff, gs_itm_buff,
           gt_hdr_t_del, gt_itm_t_del, gv_hdr_del.
  ENDMETHOD.
ENDCLASS.
