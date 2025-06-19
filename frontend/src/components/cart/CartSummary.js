import React from 'react';
import { useSelector } from 'react-redux';
import {
  Box,
  Typography,
  Paper,
  Button,
  Divider,
} from '@mui/material';
import { ShoppingBag as ShoppingBagIcon } from '@mui/icons-material';
import {
  selectCartItems,
  selectCartDrinks,
  selectCartTotal,
  selectCartItemsCount
} from '../../store/cart/cartSlice';
import { formatDate } from '../../utils/dateUtils';

const CartSummary = ({ onCheckout, showCheckoutButton = true }) => {
  const cartItems = useSelector(selectCartItems);
  const cartDrinks = useSelector(selectCartDrinks);
  const cartTotal = useSelector(selectCartTotal);
  const itemCount = useSelector(selectCartItemsCount);
  const abholDatum = useSelector(state => state.cart.abholDatum);
  const abholZeit = useSelector(state => state.cart.abholZeit);

  const isEmpty = cartItems.length === 0 && cartDrinks.length === 0;

  if (isEmpty && !showCheckoutButton) {
    return null;
  }

  return (
      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h6" component="h2" gutterBottom>
          Zusammenfassung
        </Typography>

        {isEmpty ? (
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
              Ihr Warenkorb ist leer.
            </Typography>
        ) : (
            <>
              <Box sx={{ mb: 2 }}>
                <Typography variant="body2" color="text.secondary" gutterBottom>
                  {itemCount} {itemCount === 1 ? 'Artikel' : 'Artikel'} im Warenkorb
                </Typography>

                {/* Show breakdown of items vs drinks */}
                {cartItems.length > 0 && (
                    <Typography variant="body2" color="text.secondary">
                      • {cartItems.reduce((count, item) => count + item.anzahl, 0)} Gerichte
                    </Typography>
                )}
                {cartDrinks.length > 0 && (
                    <Typography variant="body2" color="text.secondary">
                      • {cartDrinks.reduce((count, item) => count + item.anzahl, 0)} Getränke
                    </Typography>
                )}

                {abholDatum && abholZeit && (
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                      Abholung am {formatDate(abholDatum)} um {abholZeit} Uhr
                    </Typography>
                )}
              </Box>

              <Divider sx={{ mb: 2 }} />

              <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
                <Typography variant="subtitle1">Zwischensumme</Typography>
                <Typography variant="subtitle1">CHF {cartTotal.toFixed(2)}</Typography>
              </Box>

              <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
                <Typography variant="h6">Gesamtsumme</Typography>
                <Typography variant="h6" color="primary.main">CHF {cartTotal.toFixed(2)}</Typography>
              </Box>
            </>
        )}

        {showCheckoutButton && (
            <Button
                variant="contained"
                color="primary"
                fullWidth
                size="large"
                onClick={onCheckout}
                disabled={isEmpty || !abholDatum || !abholZeit}
                startIcon={<ShoppingBagIcon />}
                sx={{ py: 1.5 }}
            >
              Zur Kasse
            </Button>
        )}
      </Paper>
  );
};

export default CartSummary;
