import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import MenuList from '../../components/admin/MenuList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { menuplanService } from '../../services/api';

const Menus = () => {
  const [menuPlans, setMenuPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchMenuPlans = async () => {
    setLoading(true);
    try {
      const response = await menuplanService.getAllMenuplans();
      setMenuPlans(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Menüpläne';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchMenuPlans();
  }, []);
  
  const handleDeleteMenu = async (menuId) => {
    try {
      await menuplanService.deleteMenuplan(menuId);
      toast.success('Menüplan erfolgreich gelöscht');
      
      // Menüpläne neu laden
      fetchMenuPlans();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Menüplans';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Menüpläne werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchMenuPlans} />;
  }
  
  return (
    <Box>
      <MenuList 
        menuPlans={menuPlans} 
        onDelete={handleDeleteMenu}
      />
    </Box>
  );
};

export default Menus;
