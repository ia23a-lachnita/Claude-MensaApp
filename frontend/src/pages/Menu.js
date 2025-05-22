import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
} from '@mui/material';
import { fetchWeeklyMenu } from '../store/menu/menuActions';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import MenuCard from '../components/menu/MenuCard';
import DateSelector from '../components/menu/DateSelector';

const Menu = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { weeklyMenus, selectedDate, loading, error } = useSelector(state => state.menu);
  const [currentDate, setCurrentDate] = useState(selectedDate || new Date().toISOString().split('T')[0]);
  
  useEffect(() => {
    dispatch(fetchWeeklyMenu());
  }, [dispatch]);
  
  const handleDateChange = (date) => {
    setCurrentDate(date);
  };
  
  const renderMenuCards = () => {
    if (loading) return <Loading message="Menüpläne werden geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchWeeklyMenu())} />;
    
    if (weeklyMenus && weeklyMenus.length > 0) {
      return (
        <Grid container spacing={3}>
          {weeklyMenus.map(menu => (
            <Grid item xs={12} md={6} key={menu.id}>
              <MenuCard menuplan={menu} />
            </Grid>
          ))}
        </Grid>
      );
    }
    
    return (
      <Paper sx={{ p: 3, textAlign: 'center' }}>
        <Typography variant="h6" color="text.secondary">
          Keine Menüpläne verfügbar
        </Typography>
      </Paper>
    );
  };
  
  return (
    <Box>
      <DateSelector selectedDate={currentDate} onChange={handleDateChange} />
      
      {renderMenuCards()}
    </Box>
  );
};

export default Menu;
