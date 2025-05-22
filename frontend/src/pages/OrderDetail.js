import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import ConfirmDialog from '../components/common/ConfirmDialog';
import { bestellungService } from '../services/api';

const OrderDetailPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [cancelDialogOpen, setCancelDialogOpen] = useState(false);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(id);
        setOrder(response.data);
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellung konnte nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrder();
  }, [id]);
  
  const handleStartPayment = () => {
    navigate(`/payment/${id}`);
  };
  
  const handleCancelOrder = async () => {
    try {
      await bestellungService.storniereBestellung(id);
      toast.success('Bestellung wurde storniert');
      
      // Bestellung neu laden
      const response = await bestellungService.getBestellungById(id);
      setOrder(response.data);
    } catch (error) {
      const message = error.response?.data?.message || 'Bestellung konnte nicht storniert werden';
      toast.error(message);
    } finally {
      setCancelDialogOpen(false);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bestelldetails" />
        <ErrorMessage message={error} />
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/orders')}
          sx={{ mt: 2 }}
        >
          Zurück zu meinen Bestellungen
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/orders')}
          sx={{ mr: 2 }}
        >
          Zurück
        </Button>
        <PageTitle title={`Bestellung #${order.id}`} />
      </Box>
      
      <OrderDetail 
        order={order} 
        onStartPayment={handleStartPayment}
        onCancelOrder={() => setCancelDialogOpen(true)}
      />
      
      <ConfirmDialog
        open={cancelDialogOpen}
        title="Bestellung stornieren"
        message="Möchten Sie diese Bestellung wirklich stornieren? Diese Aktion kann nicht rückgängig gemacht werden."
        confirmText="Stornieren"
        cancelText="Abbrechen"
        onConfirm={handleCancelOrder}
        onCancel={() => setCancelDialogOpen(false)}
        confirmButtonProps={{ color: 'error' }}
      />
    </Box>
  );
};

export default OrderDetailPage;
