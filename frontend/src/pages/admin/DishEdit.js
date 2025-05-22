import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DishForm from '../../components/admin/DishForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { gerichtService } from '../../services/api';

const DishEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [dish, setDish] = useState(null);
  const [loading, setLoading] = useState(isEdit);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchDish = async () => {
      if (!isEdit) {
        setLoading(false);
        return;
      }
      
      try {
        const response = await gerichtService.getGerichtById(id);
        setDish(response.data);
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden des Gerichts';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDish();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await gerichtService.updateGericht(id, formData);
        toast.success('Gericht erfolgreich aktualisiert');
      } else {
        await gerichtService.createGericht(formData);
        toast.success('Gericht erfolgreich erstellt');
      }
      
      navigate('/admin/dishes');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Gerichts';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message="Gericht wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/dishes')} />;
  }
  
  return (
    <Box>
      <DishForm 
        dish={dish} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default DishEdit;
