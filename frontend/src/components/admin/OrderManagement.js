import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  Button,
  Menu,
  MenuItem,
  IconButton,
  Typography,
  Box,
  Divider,
  TextField,
  Grid,
} from '@mui/material';
import {
  MoreVert as MoreVertIcon,
  FilterList as FilterListIcon,
  Refresh as RefreshIcon,
  ExpandMore as ExpandMoreIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel, getZahlungsStatusLabel } from '../../utils/statusUtils';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import deLocale from 'date-fns/locale/de';

const OrderManagement = ({ orders, onUpdateStatus, onRefresh }) => {
  const [statusAnchorEl, setStatusAnchorEl] = useState(null);
  const [currentOrderId, setCurrentOrderId] = useState(null);
  const [showFilters, setShowFilters] = useState(false);
  const [filterDate, setFilterDate] = useState(null);
  const [filterStatus, setFilterStatus] = useState('');
  
  const handleStatusMenuOpen = (event, orderId) => {
    setStatusAnchorEl(event.currentTarget);
    setCurrentOrderId(orderId);
  };
  
  const handleStatusMenuClose = () => {
    setStatusAnchorEl(null);
    setCurrentOrderId(null);
  };
  
  const handleStatusChange = (status) => {
    if (currentOrderId) {
      onUpdateStatus(currentOrderId, status);
    }
    handleStatusMenuClose();
  };
  
  const toggleFilters = () => {
    setShowFilters(!showFilters);
  };
  
  const handleFilterDateChange = (date) => {
    setFilterDate(date);
  };
  
  const handleFilterStatusChange = (event) => {
    setFilterStatus(event.target.value);
  };
  
  const clearFilters = () => {
    setFilterDate(null);
    setFilterStatus('');
  };
  
  // Status options for filter and change status menu
  const statusOptions = [
    { value: 'NEU', label: 'Neu' },
    { value: 'IN_ZUBEREITUNG', label: 'In Zubereitung' },
    { value: 'BEREIT', label: 'Bereit' },
    { value: 'ABGEHOLT', label: 'Abgeholt' },
    { value: 'STORNIERT', label: 'Storniert' },
  ];
  
  // Filter orders
  const filteredOrders = orders.filter(order => {
    let match = true;
    
    if (filterDate) {
      const orderDate = new Date(order.abholDatum);
      const filterDateObj = new Date(filterDate);
      
      match = match && 
        orderDate.getFullYear() === filterDateObj.getFullYear() &&
        orderDate.getMonth() === filterDateObj.getMonth() &&
        orderDate.getDate() === filterDateObj.getDate();
    }
    
    if (filterStatus) {
      match = match && order.status === filterStatus;
    }
    
    return match;
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        <Typography variant="h6" component="h2">
          Bestellungen verwalten
        </Typography>
        
        <Box>
          <Button 
            startIcon={<FilterListIcon />} 
            onClick={toggleFilters}
            endIcon={<ExpandMoreIcon sx={{ transform: showFilters ? 'rotate(180deg)' : 'rotate(0deg)' }} />}
            sx={{ mr: 1 }}
          >
            Filter
          </Button>
          <Button 
            startIcon={<RefreshIcon />} 
            onClick={onRefresh}
          >
            Aktualisieren
          </Button>
        </Box>
      </Box>
      
      {showFilters && (
        <Paper sx={{ p: 2, mb: 3 }}>
          <Typography variant="subtitle1" gutterBottom>
            Bestellungen filtern
          </Typography>
          
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} sm={4}>
              <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
                <DatePicker
                  label="Abholdatum"
                  value={filterDate}
                  onChange={handleFilterDateChange}
                  sx={{ width: '100%' }}
                  slotProps={{
                    textField: {
                      variant: 'outlined',
                      fullWidth: true,
                      size: 'small',
                    },
                  }}
                />
              </LocalizationProvider>
            </Grid>
            
            <Grid item xs={12} sm={4}>
              <TextField
                select
                fullWidth
                label="Status"
                value={filterStatus}
                onChange={handleFilterStatusChange}
                variant="outlined"
                size="small"
              >
                <MenuItem value="">Alle Status</MenuItem>
                {statusOptions.map((option) => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            
            <Grid item xs={12} sm={4}>
              <Button variant="outlined" onClick={clearFilters} fullWidth>
                Filter zurücksetzen
              </Button>
            </Grid>
          </Grid>
        </Paper>
      )}
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>Bestell-Nr.</TableCell>
              <TableCell>Kunde</TableCell>
              <TableCell>Abholdatum</TableCell>
              <TableCell>Abholzeit</TableCell>
              <TableCell>Gerichte</TableCell>
              <TableCell>Gesamt</TableCell>
              <TableCell>Zahlungsstatus</TableCell>
              <TableCell>Status</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredOrders.length > 0 ? (
              filteredOrders.map((order) => (
                <TableRow key={order.id}>
                  <TableCell>{order.id}</TableCell>
                  <TableCell>{order.userName}</TableCell>
                  <TableCell>{formatDate(order.abholDatum)}</TableCell>
                  <TableCell>{order.abholZeit}</TableCell>
                  <TableCell>{order.positionen.length}</TableCell>
                  <TableCell>CHF {order.gesamtPreis.toFixed(2)}</TableCell>
                  <TableCell>
                    <Chip 
                      label={getZahlungsStatusLabel(order.zahlungsStatus)} 
                      color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
                      size="small" 
                    />
                  </TableCell>
                  <TableCell>
                    <Chip 
                      label={getStatusLabel(order.status)} 
                      color={getStatusColor(order.status, 'mui')} 
                      size="small" 
                    />
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      aria-label="Status ändern"
                      onClick={(e) => handleStatusMenuOpen(e, order.id)}
                    >
                      <MoreVertIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Bestellungen gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Menu
        anchorEl={statusAnchorEl}
        open={Boolean(statusAnchorEl)}
        onClose={handleStatusMenuClose}
      >
        <MenuItem disabled>
          <Typography variant="caption">Status ändern zu:</Typography>
        </MenuItem>
        <Divider />
        {statusOptions.map((option) => (
          <MenuItem 
            key={option.value} 
            onClick={() => handleStatusChange(option.value)}
          >
            {option.label}
          </MenuItem>
        ))}
      </Menu>
    </>
  );
};

export default OrderManagement;
