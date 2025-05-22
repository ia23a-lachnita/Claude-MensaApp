// frontend/src/components/menu/DateSelector.js - Updated version
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Button, Typography, Paper } from '@mui/material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { addDays, format, isEqual, isWeekend, startOfDay } from 'date-fns';
import { formatDate } from '../../utils/dateUtils';

const DateSelector = ({ selectedDate, onChange }) => {
  const navigate = useNavigate();

  // Funktion zum Generieren der nächsten Werktage
  const getNextWeekdays = (count = 5) => {
    const weekdays = [];
    let currentDay = new Date();
    let daysAdded = 0;
    let dayOffset = 0;

    while (daysAdded < count) {
      const checkDate = addDays(currentDay, dayOffset);

      // Prüfen ob es ein Werktag ist (Montag = 1, Freitag = 5)
      if (!isWeekend(checkDate)) {
        let label;

        if (dayOffset === 0) {
          label = 'Heute';
        } else if (dayOffset === 1) {
          label = 'Morgen';
        } else {
          label = format(checkDate, 'EEE dd.MM.', { locale: deLocale });
        }

        weekdays.push({
          date: checkDate,
          label: label
        });
        daysAdded++;
      }
      dayOffset++;

      // Sicherheitscheck um Endlosschleife zu vermeiden
      if (dayOffset > 10) break;
    }

    return weekdays;
  };

  const dates = getNextWeekdays(5);

  const handleDateChange = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    onChange(formattedDate);
    navigate(`/menu/${formattedDate}`);
  };

  const handleQuickSelect = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    onChange(formattedDate);
    navigate(`/menu/${formattedDate}`);
  };

  const isDateSelected = (date) => {
    if (!selectedDate) return false;
    const selDate = new Date(selectedDate);
    return isEqual(
        startOfDay(new Date(date.getFullYear(), date.getMonth(), date.getDate())),
        startOfDay(new Date(selDate.getFullYear(), selDate.getMonth(), selDate.getDate()))
    );
  };

  return (
      <Paper
          elevation={2}
          sx={{
            p: 2,
            mb: 4,
            backgroundColor: (theme) => theme.palette.background.paper
          }}
      >
        <Typography variant="h6" component="h2" gutterBottom>
          Menüplan für {selectedDate ? formatDate(selectedDate) : 'Heute'}
        </Typography>

        <Box sx={{ display: 'flex', flexWrap: 'wrap', mb: 2, gap: 1 }}>
          {dates.map((item) => (
              <Button
                  key={`${item.date.getTime()}-${item.label}`}
                  variant={isDateSelected(item.date) ? 'contained' : 'outlined'}
                  color="primary"
                  size="small"
                  onClick={() => handleQuickSelect(item.date)}
                  sx={{ minWidth: '80px' }}
              >
                {item.label}
              </Button>
          ))}
        </Box>

        <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
          <DatePicker
              label="Anderes Datum wählen"
              value={selectedDate ? new Date(selectedDate) : new Date()}
              onChange={handleDateChange}
              minDate={new Date()}
              maxDate={addDays(new Date(), 30)}
              // Wochenenden in der DatePicker-Auswahl deaktivieren
              shouldDisableDate={(date) => isWeekend(date)}
              sx={{ width: '100%' }}
              slotProps={{
                textField: {
                  variant: 'outlined',
                  fullWidth: true,
                  size: 'small',
                },
              }}
          />
        </LocalizationProvider>
      </Paper>
  );
};

export default DateSelector;