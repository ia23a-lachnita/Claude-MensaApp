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
    TextField,
    IconButton,
} from '@mui/material';
import {
    Add as AddIcon,
    Remove as RemoveIcon,
    ShoppingCart as ShoppingCartIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';
import { addDrinkToCart } from '../../store/cart/cartSlice';

const DrinkCard = ({ getraenk }) => {
    const dispatch = useDispatch();
    const [quantity, setQuantity] = useState(1);
    const [btnHover, setBtnHover] = useState(false);

    const handleAddToCart = () => {
        dispatch(addDrinkToCart({ getraenk, anzahl: quantity }));
        toast.success(`${quantity}x ${getraenk.name} zum Warenkorb hinzugefügt`);
    };

    const handleIncreaseQuantity = () => {
        if (quantity < getraenk.vorrat) {
            setQuantity(quantity + 1);
        }
    };

    const handleDecreaseQuantity = () => {
        if (quantity > 1) {
            setQuantity(quantity - 1);
        }
    };

    const handleQuantityChange = (event) => {
        const value = parseInt(event.target.value, 10);
        if (!isNaN(value) && value > 0 && value <= getraenk.vorrat) {
            setQuantity(value);
        }
    };

    const isOutOfStock = !getraenk.verfuegbar || getraenk.vorrat <= 0;

    return (
        <Card
            elevation={3}
            sx={{
                height: '100%',
                display: 'flex',
                flexDirection: 'column',
                transition: 'transform 0.2s, box-shadow 0.2s',
                opacity: isOutOfStock ? 0.6 : 1,
                '&:hover': {
                    transform: isOutOfStock ? 'none' : 'translateY(-4px)',
                    boxShadow: isOutOfStock ? 3 : 6,
                },
            }}
        >
            {getraenk.bildUrl && (
                <CardMedia
                    component="img"
                    height="140"
                    image={getraenk.bildUrl}
                    alt={getraenk.name}
                />
            )}
            <CardContent sx={{ flexGrow: 1 }}>
                <Typography variant="h6" component="div" gutterBottom>
                    {getraenk.name}
                </Typography>

                {getraenk.beschreibung && (
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1.5 }}>
                        {getraenk.beschreibung.length > 100
                            ? `${getraenk.beschreibung.substring(0, 100)}...`
                            : getraenk.beschreibung}
                    </Typography>
                )}

                <Typography variant="h6" color="primary.main" sx={{ mb: 1 }}>
                    CHF {getraenk.preis.toFixed(2)}
                </Typography>

                <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                    <Typography variant="body2" color="text.secondary">
                        Vorrat: {getraenk.vorrat}
                    </Typography>
                    <Box sx={{ ml: 'auto' }}>
                        {getraenk.verfuegbar ? (
                            <Chip label="Verfügbar" size="small" color="success" variant="outlined" />
                        ) : (
                            <Chip label="Nicht verfügbar" size="small" color="error" />
                        )}
                    </Box>
                </Box>

                {isOutOfStock && (
                    <Chip
                        label="Ausverkauft"
                        size="small"
                        color="error"
                        sx={{ mb: 1 }}
                    />
                )}
            </CardContent>

            <CardActions disableSpacing>
                {!isOutOfStock && (
                    <>
                        <Box sx={{ display: 'flex', alignItems: 'center', mr: 1 }}>
                            <IconButton
                                size="small"
                                onClick={handleDecreaseQuantity}
                                disabled={quantity <= 1}
                            >
                                <RemoveIcon />
                            </IconButton>
                            <TextField
                                value={quantity}
                                onChange={handleQuantityChange}
                                size="small"
                                inputProps={{
                                    min: 1,
                                    max: getraenk.vorrat,
                                    style: { textAlign: 'center' }
                                }}
                                sx={{ width: '50px', mx: 1 }}
                            />
                            <IconButton
                                size="small"
                                onClick={handleIncreaseQuantity}
                                disabled={quantity >= getraenk.vorrat}
                            >
                                <AddIcon />
                            </IconButton>
                        </Box>

                        <Button
                            variant="contained"
                            size="small"
                            onMouseEnter={() => setBtnHover(true)}
                            onMouseLeave={() => setBtnHover(false)}
                            onClick={handleAddToCart}
                            sx={{
                                flexGrow: 1,
                                minWidth: '120px',
                                display: 'flex',
                                justifyContent: 'center',
                                alignItems: 'center',
                            }}
                        >
                            {btnHover ? <ShoppingCartIcon /> : 'Hinzufügen'}
                        </Button>
                    </>
                )}

                {isOutOfStock && (
                    <Button
                        variant="outlined"
                        size="small"
                        disabled
                        sx={{ flexGrow: 1 }}
                    >
                        Nicht verfügbar
                    </Button>
                )}
            </CardActions>
        </Card>
    );
};

export default DrinkCard;
