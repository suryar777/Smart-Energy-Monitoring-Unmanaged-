@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View - Energy Meter Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCI_EMH_22IT115
  as select from zem_hdr_22it115 as EnergyHeader
  composition [0..*] of ZCI_EMI_22IT115 as _EnergyReading
{
  key meterid               as MeterId,
      meterdesc             as MeterDesc,
      location              as Location,
      metertype             as MeterType,
      installdate           as InstallDate,
      status           as MeterStatus,
      @Semantics.amount.currencyCode: 'Currency'
      totalcost             as TotalCost,
      currency              as Currency,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _EnergyReading
}
