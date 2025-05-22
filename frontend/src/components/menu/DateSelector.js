import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Button, Typography, Paper } from '@mui/material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { addDays, format, isEqual, isToday, isTomorrow } from 'date-fns';
import { formatDate } from '../../utils/dateUtils';

const DateSelector = ({ selectedDate, onChange }) => {
  const navigate = useNavigate();
  
  const dates = [
    { date: new Date(), label: 'Heute' },
    { date: addDays(new Date(), 1), label: 'Morgen' },
    { date: addDays(new Date(), 2), label: format(addDays(new Date(), 2), 'EEE dd.MM.', { locale: deLocale }) },
    { date: addDays(new Date(), 3), label: format(addDays(new Date(), 3), 'EEE dd.MM.', { locale: deLocale }) },
    { date: addDays(new Date(), 4), label: format(addDays(new Date(), 4), 'EEE dd.MM.', { locale: deLocale }) },
  ];
  
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
      new Date(date.getFullYear(), date.getMonth(), date.getDate()),
      new Date(selDate.getFullYear(), selDate.getMonth(), selDate.getDate())
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
            key={item.label}
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
