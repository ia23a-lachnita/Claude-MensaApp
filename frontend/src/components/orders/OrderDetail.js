import React from 'react';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Chip,
  Divider,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  CalendarToday as CalendarTodayIcon,
  AccessTime as AccessTimeIcon,
  LocalDining as LocalDiningIcon,
  Payment as PaymentIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel, getZahlungsStatusLabel } from '../../utils/statusUtils';

const OrderDetail = ({ order, onStartPayment, onCancelOrder }) => {
  if (!order) return null;
  
  const canBeCancelled = order.status === 'NEU' && order.zahlungsStatus !== 'BEZAHLT';
  const needsPayment = order.zahlungsStatus === 'AUSSTEHEND';
  
  return (
    <Box>
      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 3 }}>
          <Box>
            <Typography variant="h5" component="h1">
              Bestellung #{order.id}
            </Typography>
            <Typography variant="body1" color="text.secondary">
              Bestellt am {formatDate(order.bestellDatum)}
            </Typography>
          </Box>
          <Chip 
            label={getStatusLabel(order.status)} 
            color={getStatusColor(order.status, 'mui')} 
          />
        </Box>
        
        <Grid container spacing={3}>
          <Grid item xs={12} md={6}>
            <Paper variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                <CalendarTodayIcon sx={{ mr: 1 }} /> Abholinformationen
              </Typography>
              <Typography variant="body1" paragraph>
                Datum: <strong>{formatDate(order.abholDatum)}</strong>
              </Typography>
              <Typography variant="body1">
                Uhrzeit: <strong>{order.abholZeit} Uhr</strong>
              </Typography>
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={6}>
            <Paper variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                <PaymentIcon sx={{ mr: 1 }} /> Zahlungsinformationen
              </Typography>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Typography variant="body1">
                  Status: 
                </Typography>
                <Chip 
                  label={getZahlungsStatusLabel(order.zahlungsStatus)} 
                  color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
                />
              </Box>
              {order.zahlungsReferenz && (
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  Referenz: {order.zahlungsReferenz}
                </Typography>
              )}
            </Paper>
          </Grid>
        </Grid>
        
        {order.bemerkungen && (
          <Paper variant="outlined" sx={{ p: 2, mt: 3 }}>
            <Typography variant="h6" gutterBottom>
              Bemerkungen
            </Typography>
            <Typography variant="body1">
              {order.bemerkungen}
            </Typography>
          </Paper>
        )}
        
        <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 3, gap: 2 }}>
          {canBeCancelled && (
            <Button 
              variant="outlined" 
              color="error" 
              onClick={onCancelOrder}
            >
              Bestellung stornieren
            </Button>
          )}
          
          {needsPayment && (
            <Button 
              variant="contained" 
              color="primary" 
              onClick={onStartPayment}
              startIcon={<PaymentIcon />}
            >
              Jetzt bezahlen
            </Button>
          )}
        </Box>
      </Paper>
      
      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
          <LocalDiningIcon sx={{ mr: 1 }} /> Bestellte Gerichte
        </Typography>
        
        <TableContainer component={Paper} variant="outlined" sx={{ mt: 2 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Gericht</TableCell>
                <TableCell align="right">Preis</TableCell>
                <TableCell align="right">Anzahl</TableCell>
                <TableCell align="right">Gesamt</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {order.positionen.map((position) => (
                <TableRow key={position.id}>
                  <TableCell>{position.gerichtName}</TableCell>
                  <TableCell align="right">CHF {position.einzelPreis.toFixed(2)}</TableCell>
                  <TableCell align="right">{position.anzahl}</TableCell>
                  <TableCell align="right">CHF {position.gesamtPreis.toFixed(2)}</TableCell>
                </TableRow>
              ))}
              <TableRow>
                <TableCell colSpan={3} align="right" sx={{ fontWeight: 'bold' }}>
                  Gesamtsumme:
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 'bold' }}>
                  CHF {order.gesamtPreis.toFixed(2)}
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  );
};

export default OrderDetail;
