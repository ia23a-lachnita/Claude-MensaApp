import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import OrderManagement from '../../components/admin/OrderManagement';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { bestellungService } from '../../services/api';

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchOrders = async () => {
    setLoading(true);
    try {
      const response = await bestellungService.getAllBestellungen();
      setOrders(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Bestellungen';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchOrders();
  }, []);
  
  const handleUpdateStatus = async (orderId, status) => {
    try {
      await bestellungService.updateBestellungStatus(orderId, status);
      toast.success('Status erfolgreich aktualisiert');
      
      // Bestellungen neu laden
      fetchOrders();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Status';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellungen werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchOrders} />;
  }
  
  return (
    <Box>
      <OrderManagement 
        orders={orders} 
        onUpdateStatus={handleUpdateStatus} 
        onRefresh={fetchOrders}
      />
    </Box>
  );
};

export default Orders;
