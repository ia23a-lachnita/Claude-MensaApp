/**
 * Gibt den Anzeigenamen für einen Bestellstatus zurück
 * @param {string} status - Der Bestellstatus
 * @returns {string} Der Anzeigename des Status
 */
export const getStatusLabel = (status) => {
  switch (status) {
    case 'NEU':
      return 'Neu';
    case 'IN_ZUBEREITUNG':
      return 'In Zubereitung';
    case 'BEREIT':
      return 'Bereit zur Abholung';
    case 'ABGEHOLT':
      return 'Abgeholt';
    case 'STORNIERT':
      return 'Storniert';
    default:
      return status;
  }
};

/**
 * Gibt den Anzeigenamen für einen Zahlungsstatus zurück
 * @param {string} status - Der Zahlungsstatus
 * @returns {string} Der Anzeigename des Status
 */
export const getZahlungsStatusLabel = (status) => {
  switch (status) {
    case 'AUSSTEHEND':
      return 'Ausstehend';
    case 'BEZAHLT':
      return 'Bezahlt';
    case 'STORNIERT':
      return 'Storniert';
    default:
      return status;
  }
};

/**
 * Gibt die Farbe für einen Bestellstatus zurück
 * @param {string} status - Der Bestellstatus
 * @param {string} type - Der Typ der Farbe ('mui' für Material-UI Farben, sonst CSS-Farben)
 * @returns {string} Die Farbe für den Status
 */
export const getStatusColor = (status, type = 'css') => {
  let color;
  
  switch (status) {
    case 'NEU':
      color = type === 'mui' ? 'info' : '#2196f3';
      break;
    case 'IN_ZUBEREITUNG':
      color = type === 'mui' ? 'warning' : '#ff9800';
      break;
    case 'BEREIT':
      color = type === 'mui' ? 'success' : '#4caf50';
      break;
    case 'ABGEHOLT':
      color = type === 'mui' ? 'success' : '#4caf50';
      break;
    case 'STORNIERT':
      color = type === 'mui' ? 'error' : '#f44336';
      break;
    default:
      color = type === 'mui' ? 'default' : '#9e9e9e';
  }
  
  return color;
};
