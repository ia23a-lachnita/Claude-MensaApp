import { format, isToday, isYesterday, isTomorrow, parseISO } from 'date-fns';
import { de } from 'date-fns/locale';

/**
 * Formatiert ein Datum für die Anzeige
 * @param {string|Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatDate = (date) => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;

  if (isToday(dateObj)) {
    return 'Heute';
  } else if (isYesterday(dateObj)) {
    return 'Gestern';
  } else if (isTomorrow(dateObj)) {
    return 'Morgen';
  } else {
    return format(dateObj, 'EEEE, dd. MMMM yyyy', { locale: de });
  }
};

/**
 * Formatiert ein Datum als kurzes Datum (DD.MM.YYYY)
 * @param {string|Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatShortDate = (date) => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'dd.MM.yyyy');
};

/**
 * Formatiert ein Datum als ISO-String (YYYY-MM-DD) für API-Aufrufe
 * @param {Date|string} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatISODate = (date) => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'yyyy-MM-dd');
};

/**
 * Konvertiert ein Datum oder Timestamp zu einem sauberen Datumsstring für API-Aufrufe
 * @param {Date|string} date - Das zu konvertierende Datum
 * @returns {string} Das Datum im Format YYYY-MM-DD
 */
export const toAPIDateString = (date) => {
  if (!date) return '';

  if (typeof date === 'string') {
    // Wenn es bereits ein ISO-String ist, extrahiere nur den Datumsteil
    if (date.includes('T')) {
      return date.split('T')[0];
    }
    // Wenn es bereits ein Datum ist, gib es zurück
    if (date.match(/^\d{4}-\d{2}-\d{2}$/)) {
      return date;
    }
    // Ansonsten versuche es zu parsen
    try {
      return formatISODate(parseISO(date));
    } catch {
      return '';
    }
  }

  if (date instanceof Date) {
    return formatISODate(date);
  }

  return '';
};
