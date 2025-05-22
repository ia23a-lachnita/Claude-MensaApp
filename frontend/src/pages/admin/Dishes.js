import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DishList from '../../components/admin/DishList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { gerichtService } from '../../services/api';

const Dishes = () => {
  const [dishes, setDishes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchDishes = async () => {
    setLoading(true);
    try {
      const response = await gerichtService.getAllGerichte();
      setDishes(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Gerichte';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchDishes();
  }, []);
  
  const handleDeleteDish = async (dishId) => {
    try {
      await gerichtService.deleteGericht(dishId);
      toast.success('Gericht erfolgreich gelöscht');
      
      // Gerichte neu laden
      fetchDishes();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Gerichts';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Gerichte werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchDishes} />;
  }
  
  return (
    <Box>
      <DishList 
        dishes={dishes} 
        onDelete={handleDeleteDish}
      />
    </Box>
  );
};

export default Dishes;
