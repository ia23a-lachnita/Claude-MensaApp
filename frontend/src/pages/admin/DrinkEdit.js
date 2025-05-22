import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DrinkForm from '../../components/admin/DrinkForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { getraenkService } from '../../services/api';

const DrinkEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [drink, setDrink] = useState(null);
  const [loading, setLoading] = useState(isEdit);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchDrink = async () => {
      if (!isEdit) {
        setLoading(false);
        return;
      }
      
      try {
        const response = await getraenkService.getGetraenkById(id);
        setDrink(response.data);
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden des Getränks';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDrink();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await getraenkService.updateGetraenk(id, formData);
        toast.success('Getränk erfolgreich aktualisiert');
      } else {
        await getraenkService.createGetraenk(formData);
        toast.success('Getränk erfolgreich erstellt');
      }
      
      navigate('/admin/drinks');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Getränks';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message="Getränk wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/drinks')} />;
  }
  
  return (
    <Box>
      <DrinkForm 
        drink={drink} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default DrinkEdit;
