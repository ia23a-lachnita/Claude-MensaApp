import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  TextField,
} from '@mui/material';
import { TimePicker } from '@mui/x-date-pickers/TimePicker';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { addDays, format, isToday, parseISO, set } from 'date-fns';
import { setAbholDatum, setAbholZeit, setBemerkungen } from '../../store/cart/cartSlice';

const PickupSelector = () => {
  const dispatch = useDispatch();
  const selectedDate = useSelector(state => state.cart.abholDatum);
  const selectedTime = useSelector(state => state.cart.abholZeit);
  const bemerkungen = useSelector(state => state.cart.bemerkungen);
  
  const [minTime, setMinTime] = useState(null);
  
  // Set default date to today if not selected
  useEffect(() => {
    if (!selectedDate) {
      handleDateChange(new Date());
    } else {
      updateMinTime(selectedDate);
    }
  }, [selectedDate]);
  
  const handleDateChange = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    dispatch(setAbholDatum(formattedDate));
    updateMinTime(formattedDate);
    
    // If time is now out of range, reset it
    if (selectedTime) {
      const timeObj = parseTimeString(selectedTime);
      if (isToday(parseISO(formattedDate)) && (timeObj.getHours() < 10 || timeObj.getHours() >= 15)) {
        dispatch(setAbholZeit(null));
      }
    }
  };
  
  const handleTimeChange = (time) => {
    if (time) {
      const formattedTime = format(time, 'HH:mm');
      dispatch(setAbholZeit(formattedTime));
    } else {
      dispatch(setAbholZeit(null));
    }
  };
  
  const handleBemerkungenChange = (event) => {
    dispatch(setBemerkungen(event.target.value));
  };
  
  const updateMinTime = (date) => {
    if (isToday(parseISO(date))) {
      const now = new Date();
      // Set min time to 10:00 or current time + 30 min (whichever is later)
      const minTimeDate = set(now, { hours: 10, minutes: 0, seconds: 0 });
      const currentPlusBuffer = set(now, { 
        minutes: now.getMinutes() + 30, 
        seconds: 0 
      });
      
      setMinTime(currentPlusBuffer > minTimeDate ? currentPlusBuffer : minTimeDate);
    } else {
      // Set min time to 10:00 for future dates
      setMinTime(set(new Date(), { hours: 10, minutes: 0, seconds: 0 }));
    }
  };
  
  const parseTimeString = (timeString) => {
    const [hours, minutes] = timeString.split(':').map(Number);
    return set(new Date(), { hours, minutes, seconds: 0 });
  };
  
  return (
    <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Abholzeit auswählen
      </Typography>
      
      <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
        <Grid container spacing={3}>
          <Grid item xs={12} sm={6}>
            <DatePicker
              label="Abholdatum"
              value={selectedDate ? parseISO(selectedDate) : null}
              onChange={handleDateChange}
              minDate={new Date()}
              maxDate={addDays(new Date(), 7)}
              sx={{ width: '100%' }}
              slotProps={{
                textField: {
                  variant: 'outlined',
                  fullWidth: true,
                  required: true,
                  helperText: 'Bitte wählen Sie ein Datum aus',
                },
              }}
            />
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <TimePicker
              label="Abholzeit"
              value={selectedTime ? parseTimeString(selectedTime) : null}
              onChange={handleTimeChange}
              minTime={minTime}
              maxTime={set(new Date(), { hours: 14, minutes: 30 })}
              sx={{ width: '100%' }}
              slotProps={{
                textField: {
                  variant: 'outlined',
                  fullWidth: true,
                  required: true,
                  helperText: 'Verfügbar zwischen 10:00 und 14:30 Uhr',
                },
              }}
            />
          </Grid>
          
          <Grid item xs={12}>
            <TextField
              label="Bemerkungen zur Bestellung (optional)"
              multiline
              rows={3}
              value={bemerkungen}
              onChange={handleBemerkungenChange}
              variant="outlined"
              fullWidth
              placeholder="Spezielle Wünsche oder Informationen"
            />
          </Grid>
        </Grid>
      </LocalizationProvider>
    </Paper>
  );
};

export default PickupSelector;
