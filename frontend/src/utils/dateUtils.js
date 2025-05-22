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
 * Formatiert ein Datum als ISO-String (YYYY-MM-DD)
 * @param {Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatISODate = (date) => {
  if (!date) return '';
  return format(date, 'yyyy-MM-dd');
};
