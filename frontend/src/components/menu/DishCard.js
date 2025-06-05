import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import {
  Card,
  CardContent,
  CardActions,
  CardMedia,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  IconButton,
  Collapse,
  TextField,
} from '@mui/material';
import {
  ExpandMore as ExpandMoreIcon,
  Info as InfoIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
} from '@mui/icons-material';
import { styled } from '@mui/material/styles';
import { addToCart } from '../../store/cart/cartSlice';
import { toast } from 'react-toastify';

const ExpandMore = styled((props) => {
  const { expand, ...other } = props;
  return <IconButton {...other} />;
})(({ theme, expand }) => ({
  transform: !expand ? 'rotate(0deg)' : 'rotate(180deg)',
  marginLeft: 'auto',
  transition: theme.transitions.create('transform', {
    duration: theme.transitions.duration.shortest,
  }),
}));

const DishCard = ({ gericht }) => {
  const dispatch = useDispatch();
  const [expanded, setExpanded] = useState(false);
  const [quantity, setQuantity] = useState(1);

  // NEW: hover state for the "Hinzufügen" button
  const [btnHover, setBtnHover] = useState(false);

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  const handleAddToCart = () => {
    dispatch(addToCart({ gericht, anzahl: quantity }));
    toast.success(`${quantity}x ${gericht.name} zum Warenkorb hinzugefügt`);
  };

  const handleIncreaseQuantity = () => {
    setQuantity(quantity + 1);
  };

  const handleDecreaseQuantity = () => {
    if (quantity > 1) {
      setQuantity(quantity - 1);
    }
  };

  const handleQuantityChange = (event) => {
    const value = parseInt(event.target.value, 10);
    if (!isNaN(value) && value > 0) {
      setQuantity(value);
    }
  };

  return (
      <Card
          elevation={3}
          sx={{
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            transition: 'transform 0.2s, box-shadow 0.2s',
            '&:hover': {
              transform: 'translateY(-4px)',
              boxShadow: 6,
            },
          }}
      >
        {gericht.bildUrl && (
            <CardMedia
                component="img"
                height="140"
                image={gericht.bildUrl}
                alt={gericht.name}
            />
        )}
        <CardContent sx={{ flexGrow: 1 }}>
          <Typography variant="h6" component="div" gutterBottom>
            {gericht.name}
          </Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 1.5 }}>
            {gericht.beschreibung && gericht.beschreibung.length > 100
                ? `${gericht.beschreibung.substring(0, 100)}...`
                : gericht.beschreibung}
          </Typography>
          <Typography variant="h6" color="primary.main" sx={{ mb: 1.5 }}>
            CHF {gericht.preis.toFixed(2)}
          </Typography>
          <Box sx={{ mt: 1, mb: 1.5 }}>
            {gericht.vegetarisch && (
                <Chip
                    label="Vegetarisch"
                    size="small"
                    color="success"
                    variant="outlined"
                    sx={{ mr: 0.5, mb: 0.5 }}
                />
            )}
            {gericht.vegan && (
                <Chip
                    label="Vegan"
                    size="small"
                    color="success"
                    sx={{ mr: 0.5, mb: 0.5 }}
                />
            )}
          </Box>
        </CardContent>
        <Divider />
        <CardActions disableSpacing>
          <Box sx={{ display: 'flex', alignItems: 'center', mr: 1 }}>
            <IconButton size="small" onClick={handleDecreaseQuantity}>
              <RemoveIcon />
            </IconButton>
            <TextField
                value={quantity}
                onChange={handleQuantityChange}
                size="small"
                inputProps={{ min: 1, style: { textAlign: 'center' } }}
                sx={{ width: '40px', mx: 1 }}
            />
            <IconButton size="small" onClick={handleIncreaseQuantity}>
              <AddIcon />
            </IconButton>
          </Box>

          {/*
          MODIFIED Button:
          1. Remove startIcon prop
          2. Add onMouseEnter / onMouseLeave to track hover
          3. Conditionally render text or icon
          4. Give it a fixed/min-width so it doesn’t resize when the content changes
        */}
          <Button
              variant="contained"
              size="small"
              onMouseEnter={() => setBtnHover(true)}
              onMouseLeave={() => setBtnHover(false)}
              onClick={handleAddToCart}
              sx={{
                flexGrow: 1,
                // Force a consistent width so the button does not “jump” when switching content:
                // adjust 120px to whatever suits your layout (just ensure it’s wide enough for the text).
                minWidth: '120px',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
              }}
          >
            {btnHover ? <AddIcon /> : 'Hinzufügen'}
          </Button>

          <ExpandMore
              expand={expanded}
              onClick={handleExpandClick}
              aria-expanded={expanded}
              aria-label="mehr anzeigen"
          >
            <InfoIcon />
          </ExpandMore>
        </CardActions>
        <Collapse in={expanded} timeout="auto" unmountOnExit>
          <CardContent>
            {gericht.zutaten && gericht.zutaten.length > 0 && (
                <>
                  <Typography variant="subtitle2" gutterBottom>
                    Zutaten:
                  </Typography>
                  <Typography variant="body2" paragraph>
                    {gericht.zutaten.join(', ')}
                  </Typography>
                </>
            )}

            {gericht.allergene && gericht.allergene.length > 0 && (
                <>
                  <Typography variant="subtitle2" gutterBottom>
                    Allergene:
                  </Typography>
                  <Box
                      sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, mb: 1.5 }}
                  >
                    {gericht.allergene.map((allergen) => (
                        <Chip
                            key={allergen}
                            label={allergen}
                            size="small"
                            color="error"
                            variant="outlined"
                        />
                    ))}
                  </Box>
                </>
            )}
          </CardContent>
        </Collapse>
      </Card>
  );
};

export default DishCard;
