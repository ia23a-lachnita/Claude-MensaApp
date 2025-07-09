import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  Stack,
  Divider,
} from '@mui/material';
import {
  CheckCircle as CheckCircleIcon,
  Home as HomeIcon,
  ViewList as ViewListIcon,
  Receipt as ReceiptIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import { bestellungService } from '../services/api';
import { formatDate } from '../utils/dateUtils';

const OrderConfirmation = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(orderId);
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
  }, [orderId]);
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bestellbestätigung" />
        <ErrorMessage message={error} />
        <Button
          variant="contained"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
          sx={{ mt: 2 }}
        >
          Zur Startseite
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <Paper 
        elevation={3} 
        sx={{ 
          p: 4, 
          mb: 4, 
          textAlign: 'center',
          bgcolor: order.zahlungsStatus === 'BEZAHLT' ? 'success.light' : 'warning.light',
          color: order.zahlungsStatus === 'BEZAHLT' ? 'success.contrastText' : 'warning.contrastText' 
        }}
      >
        <CheckCircleIcon sx={{ fontSize: 60, mb: 2 }} />
        <Typography variant="h4" component="h1" gutterBottom>
          {order.zahlungsStatus === 'BEZAHLT' ? 'Vielen Dank für Ihre Bestellung!' : 'Bestellung aufgenommen'}
        </Typography>
        <Typography variant="h6" gutterBottom>
          Ihre Bestellung #{order.id} wurde erfolgreich aufgenommen.
        </Typography>
        {order.zahlungsStatus === 'BEZAHLT' && (
          <>
            <Typography variant="body1" sx={{ mb: 2 }}>
              Ihre Zahlung wurde erfolgreich verarbeitet.
            </Typography>
            <Typography variant="body1">
              Ihr Essen wird am {formatDate(order.abholDatum)} um {order.abholZeit} Uhr für Sie bereit sein.
            </Typography>
          </>
        )}
        {order.zahlungsStatus !== 'BEZAHLT' && (
          <Box sx={{ 
            mt: 2, 
            p: 2, 
            bgcolor: 'error.light', 
            color: 'error.contrastText',
            borderRadius: 1,
            border: 2,
            borderColor: 'error.main'
          }}>
            <Typography variant="body1" sx={{ fontWeight: 'bold', mb: 1 }}>
              ⚠️ WICHTIG: Bestellung nicht abholbar!
            </Typography>
            <Typography variant="body1">
              Diese Bestellung kann erst nach erfolgreicher Bezahlung abgeholt werden.
              Bitte bezahlen Sie Ihre Bestellung, um sie abholen zu können.
            </Typography>
          </Box>
        )}
      </Paper>
      
      <OrderDetail order={order} />
      
      <Stack
        direction={{ xs: 'column', sm: 'row' }}
        spacing={2}
        justifyContent="center"
        sx={{ mt: 4 }}
      >
        <Button
          variant="outlined"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
        >
          Zur Startseite
        </Button>
        <Button
          variant="contained"
          startIcon={<ViewListIcon />}
          onClick={() => navigate('/orders')}
        >
          Meine Bestellungen
        </Button>
      </Stack>
    </Box>
  );
};

export default OrderConfirmation;
