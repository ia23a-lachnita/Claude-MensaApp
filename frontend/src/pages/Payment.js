import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  CircularProgress,
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import PaymentForm from '../components/orders/PaymentForm';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import { bestellungService, zahlungService } from '../services/api';

const Payment = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [processingPayment, setProcessingPayment] = useState(false);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(orderId);
        setOrder(response.data);
        
        // Wenn die Bestellung bereits bezahlt ist, zur Bestätigungsseite navigieren
        if (response.data.zahlungsStatus === 'BEZAHLT') {
          navigate(`/order-confirmation/${orderId}`);
        }
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellung konnte nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrder();
  }, [orderId, navigate]);
  
  const handlePaymentSubmit = async (paymentData) => {
    setProcessingPayment(true);
    try {
      await zahlungService.processZahlung(orderId, paymentData);
      toast.success('Zahlung erfolgreich');
      navigate(`/order-confirmation/${orderId}`);
    } catch (error) {
      const message = error.response?.data?.message || 'Zahlung konnte nicht verarbeitet werden';
      toast.error(message);
      setProcessingPayment(false);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bezahlung" />
        <ErrorMessage 
          message={error} 
          onRetry={() => navigate(`/orders/${orderId}`)} 
        />
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate(-1)}
          sx={{ mt: 2 }}
        >
          Zurück
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <PageTitle 
        title="Bezahlung" 
        subtitle="Schliessen Sie Ihre Bestellung mit der Bezahlung ab" 
      />
      
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <PaymentForm 
            order={order} 
            onSubmit={handlePaymentSubmit} 
            loading={processingPayment} 
          />
        </Grid>
        
        <Grid item xs={12} md={6}>
          <OrderDetail 
            order={order} 
            hideButtons={true}
          />
        </Grid>
      </Grid>
    </Box>
  );
};

export default Payment;
