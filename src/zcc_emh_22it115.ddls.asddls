@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Energy Meter Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCC_EMH_22IT115
  provider contract transactional_query
  as projection on ZCI_EMH_22IT115
{
  key MeterId,
      MeterDesc,
      Location,
      MeterType,
      InstallDate,
      MeterStatus,
      @Semantics.amount.currencyCode: 'Currency'
      TotalCost,
      Currency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      _EnergyReading : redirected to composition child ZCC_EMI_22IT115
}
