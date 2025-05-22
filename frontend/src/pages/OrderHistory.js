import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Paper,
  Grid,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderCard from '../components/orders/OrderCard';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import EmptyState from '../components/common/EmptyState';
import { bestellungService } from '../services/api';

const OrderHistory = () => {
  const navigate = useNavigate();
  
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const response = await bestellungService.getMyBestellungen();
        setOrders(response.data);
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellungen konnten nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrders();
  }, []);
  
  if (loading) {
    return <Loading message="Bestellungen werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => window.location.reload()} />;
  }
  
  if (orders.length === 0) {
    return (
      <Box>
        <PageTitle title="Meine Bestellungen" />
        <EmptyState
          title="Keine Bestellungen gefunden"
          message="Sie haben noch keine Bestellungen aufgegeben."
          actionText="Menü anzeigen"
          onAction={() => navigate('/menu')}
          icon={ReceiptIcon}
        />
      </Box>
    );
  }
  
  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <PageTitle title="Meine Bestellungen" />
        
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => navigate('/menu')}
        >
          Neue Bestellung
        </Button>
      </Box>
      
      <Grid container spacing={3}>
        {orders.map(order => (
          <Grid item xs={12} key={order.id}>
            <OrderCard order={order} />
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default OrderHistory;
