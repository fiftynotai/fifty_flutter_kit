/// Printing modes that determine how tickets are routed to printers
enum PrintingMode {
  /// Send ticket to all registered printers
  printToAll,

  /// User selects printer(s) before each print operation
  selectPerPrint,

  /// Route tickets based on printer roles
  roleBasedRouting,
}
