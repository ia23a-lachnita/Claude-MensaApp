import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  Grid,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  AccessTime as AccessTimeIcon,
  CalendarToday as CalendarTodayIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel } from '../../utils/statusUtils';

const OrderCard = ({ order }) => {
  const navigate = useNavigate();
  
  const handleViewDetails = () => {
    navigate(`/orders/${order.id}`);
  };
  
  return (
    <Card 
      elevation={2} 
      sx={{ 
        mb: 2, 
        borderLeft: 4, 
        borderColor: getStatusColor(order.status),
        transition: 'transform 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
        },
      }}
    >
      <CardContent>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
          <Box>
            <Typography variant="h6" component="div">
              Bestellung #{order.id}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Bestellt am {formatDate(order.bestellDatum)}
            </Typography>
          </Box>
          <Chip 
            label={getStatusLabel(order.status)} 
            color={getStatusColor(order.status, 'mui')} 
            size="small"
          />
        </Box>
        
        <Grid container spacing={2}>
          <Grid item xs={12} sm={6}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
              <CalendarTodayIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                Abholung am {formatDate(order.abholDatum)}
              </Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <AccessTimeIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                Uhrzeit: {order.abholZeit} Uhr
              </Typography>
            </Box>
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
              <ReceiptIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                {order.positionen.length} {order.positionen.length === 1 ? 'Position' : 'Positionen'}
              </Typography>
            </Box>
            <Typography variant="subtitle1" color="primary.main">
              CHF {order.gesamtPreis.toFixed(2)}
            </Typography>
          </Grid>
        </Grid>
        
        <Divider sx={{ my: 1.5 }} />
        
        <Box>
          <Typography variant="body2" component="div" sx={{ mb: 1 }}>
            Zahlungsstatus: <Chip 
              label={order.zahlungsStatus === 'BEZAHLT' ? 'Bezahlt' : 'Ausstehend'} 
              color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
              size="small" 
              sx={{ ml: 1 }}
            />
          </Typography>
          {order.zahlungsStatus !== 'BEZAHLT' && (
            <Typography variant="body2" color="error.main" sx={{ fontWeight: 'bold', display: 'flex', alignItems: 'center' }}>
              ⚠️ Nicht abholbar - Zahlung erforderlich
            </Typography>
          )}
          {order.zahlungsStatus === 'BEZAHLT' && (
            <Typography variant="body2" color="success.main" sx={{ fontWeight: 'bold', display: 'flex', alignItems: 'center' }}>
              Abholbar
            </Typography>
          )}
        </Box>
      </CardContent>
      <CardActions>
        <Button size="small" onClick={handleViewDetails}>
          Details anzeigen
        </Button>
      </CardActions>
    </Card>
  );
};

export default OrderCard;
