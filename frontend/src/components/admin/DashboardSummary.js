import React from 'react';
import {
  Box,
  Paper,
  Typography,
  Grid,
  Card,
  CardContent,
  List,
  ListItem,
  ListItemText,
  Divider,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  ShoppingCart as ShoppingCartIcon,
  Person as PersonIcon,
  AttachMoney as AttachMoneyIcon,
  TrendingUp as TrendingUpIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';

const DashboardSummary = ({ stats, todaysOrders }) => {
  return (
    <Box>
      <Typography variant="h5" component="h1" gutterBottom>
        Dashboard Übersicht
      </Typography>
      
      <Grid container spacing={3} sx={{ mb: 3 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'primary.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Bestellungen heute
              </Typography>
              <ShoppingCartIcon color="primary" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.ordersToday}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'success.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Gerichte im Menü
              </Typography>
              <RestaurantIcon color="success" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.dishCount}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'info.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Registrierte Benutzer
              </Typography>
              <PersonIcon color="info" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.userCount}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'secondary.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Umsatz heute
              </Typography>
              <AttachMoneyIcon color="secondary" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              CHF {stats.revenue.toFixed(2)}
            </Typography>
          </Paper>
        </Grid>
      </Grid>
      
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Bestellungen für heute ({formatDate(new Date())})
            </Typography>
            
            {todaysOrders.length > 0 ? (
              <List>
                {todaysOrders.map((order, index) => (
                  <React.Fragment key={order.id}>
                    {index > 0 && <Divider component="li" />}
                    <ListItem>
                      <ListItemText
                        primary={`#${order.id} - ${order.userName}`}
                        secondary={
                          <>
                            <Typography component="span" variant="body2">
                              {order.abholZeit} Uhr | {order.positionen.length} Artikel | CHF {order.gesamtPreis.toFixed(2)}
                            </Typography>
                            <br />
                            <Typography component="span" variant="body2" color="text.secondary">
                              Status: {order.status}
                            </Typography>
                          </>
                        }
                      />
                    </ListItem>
                  </React.Fragment>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                Keine Bestellungen für heute
              </Typography>
            )}
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Beliebteste Gerichte
            </Typography>
            
            {stats.popularDishes && stats.popularDishes.length > 0 ? (
              <List>
                {stats.popularDishes.map((dish, index) => (
                  <React.Fragment key={dish.id}>
                    {index > 0 && <Divider component="li" />}
                    <ListItem>
                      <ListItemText
                        primary={dish.name}
                        secondary={`${dish.orderCount} Bestellungen`}
                      />
                    </ListItem>
                  </React.Fragment>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                Keine Daten verfügbar
              </Typography>
            )}
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default DashboardSummary;
