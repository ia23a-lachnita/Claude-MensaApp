import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import MenuForm from '../../components/admin/MenuForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { menuplanService, gerichtService } from '../../services/api';

const MenuEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [menuplan, setMenuplan] = useState(null);
  const [dishes, setDishes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Alle Gerichte laden
        const dishesResponse = await gerichtService.getAllGerichte();
        setDishes(dishesResponse.data);
        
        // Wenn im Bearbeitungsmodus, Menüplan laden
        if (isEdit) {
          const menuResponse = await menuplanService.getMenuplanById(id);
          setMenuplan(menuResponse.data);
        }
        
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden der Daten';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await menuplanService.updateMenuplan(id, formData);
        toast.success('Menüplan erfolgreich aktualisiert');
      } else {
        await menuplanService.createMenuplan(formData);
        toast.success('Menüplan erfolgreich erstellt');
      }
      
      navigate('/admin/menus');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Menüplans';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message={isEdit ? 'Menüplan wird geladen...' : 'Daten werden geladen...'} />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/menus')} />;
  }
  
  return (
    <Box>
      <MenuForm 
        menuplan={menuplan} 
        dishes={dishes} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default MenuEdit;
