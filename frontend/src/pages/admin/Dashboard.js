import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  CircularProgress,
} from '@mui/material';
import { toast } from 'react-toastify';

import DashboardSummary from '../../components/admin/DashboardSummary';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { bestellungService, menuplanService, userService, gerichtService } from '../../services/api';

const Dashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    ordersToday: 0,
    dishCount: 0,
    userCount: 0,
    revenue: 0,
    popularDishes: []
  });
  const [todaysOrders, setTodaysOrders] = useState([]);
  
  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const today = new Date().toISOString().split('T')[0];
        
        // Bestellungen für heute laden
        const ordersResponse = await bestellungService.getBestellungenByDatum(today);
        const orders = ordersResponse.data;
        setTodaysOrders(orders);
        
        // Anzahl der Gerichte laden
        const dishesResponse = await gerichtService.getAllGerichte();
        const dishes = dishesResponse.data;
        
        // Benutzer laden
        const usersResponse = await userService.getAllUsers();
        const users = usersResponse.data;
        
        // Gesamtumsatz für heute berechnen
        const revenue = orders
          .filter(order => order.zahlungsStatus === 'BEZAHLT')
          .reduce((total, order) => total + order.gesamtPreis, 0);
        
        // Beliebte Gerichte ermitteln
        const dishOrderCounts = {};
        orders.forEach(order => {
          order.positionen.forEach(position => {
            if (!dishOrderCounts[position.gerichtId]) {
              dishOrderCounts[position.gerichtId] = {
                id: position.gerichtId,
                name: position.gerichtName,
                orderCount: 0
              };
            }
            dishOrderCounts[position.gerichtId].orderCount += position.anzahl;
          });
        });
        
        const popularDishes = Object.values(dishOrderCounts)
          .sort((a, b) => b.orderCount - a.orderCount)
          .slice(0, 5);
        
        setStats({
          ordersToday: orders.length,
          dishCount: dishes.length,
          userCount: users.length,
          revenue,
          popularDishes
        });
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden der Dashboard-Daten';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDashboardData();
  }, []);
  
  if (loading) {
    return <Loading message="Dashboard wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => window.location.reload()} />;
  }
  
  return (
    <Box>
      <DashboardSummary stats={stats} todaysOrders={todaysOrders} />
    </Box>
  );
};

export default Dashboard;
