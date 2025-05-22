import React from 'react';
import { useDispatch } from 'react-redux';
import {
  Box,
  IconButton,
  Typography,
  Grid,
  TextField,
  Paper,
  Divider,
} from '@mui/material';
import {
  Delete as DeleteIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
} from '@mui/icons-material';
import {
  removeFromCart,
  updateCartItemQuantity,
} from '../../store/cart/cartSlice';

const CartItem = ({ item }) => {
  const dispatch = useDispatch();
  const { gericht, anzahl } = item;
  
  const handleRemove = () => {
    dispatch(removeFromCart(gericht.id));
  };
  
  const handleIncrease = () => {
    dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: anzahl + 1 }));
  };
  
  const handleDecrease = () => {
    if (anzahl > 1) {
      dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: anzahl - 1 }));
    } else {
      handleRemove();
    }
  };
  
  const handleQuantityChange = (event) => {
    const value = parseInt(event.target.value, 10);
    if (!isNaN(value) && value > 0) {
      dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: value }));
    } else if (value === 0) {
      handleRemove();
    }
  };
  
  const totalPrice = gericht.preis * anzahl;
  
  return (
    <Paper
      elevation={1}
      sx={{
        p: 2,
        mb: 2,
        '&:last-child': {
          mb: 0,
        },
      }}
    >
      <Grid container spacing={2} alignItems="center">
        <Grid item xs={12} sm={6}>
          <Typography variant="subtitle1" component="div">
            {gericht.name}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {gericht.vegetarisch && 'Vegetarisch'} 
            {gericht.vegetarisch && gericht.vegan && ' · '}
            {gericht.vegan && 'Vegan'}
          </Typography>
        </Grid>
        
        <Grid item xs={12} sm={6}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <IconButton
                size="small"
                onClick={handleDecrease}
                aria-label="Menge reduzieren"
              >
                <RemoveIcon fontSize="small" />
              </IconButton>
              
              <TextField
                value={anzahl}
                onChange={handleQuantityChange}
                inputProps={{
                  min: 1,
                  style: { textAlign: 'center', width: '30px' },
                }}
                variant="standard"
                sx={{ mx: 1, width: '40px' }}
              />
              
              <IconButton
                size="small"
                onClick={handleIncrease}
                aria-label="Menge erhöhen"
              >
                <AddIcon fontSize="small" />
              </IconButton>
            </Box>
            
            <Box sx={{ textAlign: 'right', minWidth: '80px' }}>
              <Typography variant="subtitle2" component="div">
                CHF {totalPrice.toFixed(2)}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                (CHF {gericht.preis.toFixed(2)} pro Stück)
              </Typography>
            </Box>
            
            <IconButton
              edge="end"
              aria-label="Entfernen"
              onClick={handleRemove}
              sx={{ ml: 1 }}
              color="error"
            >
              <DeleteIcon />
            </IconButton>
          </Box>
        </Grid>
      </Grid>
    </Paper>
  );
};

export default CartItem;
