import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DrinkList from '../../components/admin/DrinkList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { getraenkService } from '../../services/api';

const Drinks = () => {
  const [drinks, setDrinks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchDrinks = async () => {
    setLoading(true);
    try {
      const response = await getraenkService.getAllGetraenke();
      setDrinks(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Getränke';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchDrinks();
  }, []);
  
  const handleDeleteDrink = async (drinkId) => {
    try {
      await getraenkService.deleteGetraenk(drinkId);
      toast.success('Getränk erfolgreich gelöscht');
      
      // Getränke neu laden
      fetchDrinks();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Getränks';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Getränke werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchDrinks} />;
  }
  
  return (
    <Box>
      <DrinkList 
        drinks={drinks} 
        onDelete={handleDeleteDrink}
      />
    </Box>
  );
};

export default Drinks;
