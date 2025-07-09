import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { useSelector } from 'react-redux';
import {
    AppBar,
    Box,
    Toolbar,
    IconButton,
    Typography,
    Container,
    Avatar,
    Button,
    Menu,
    MenuItem,
    Badge,
    Drawer,
    List,
    ListItem,
    ListItemIcon,
    ListItemText,
    Divider,
} from '@mui/material';
import {
    Menu as MenuIcon,
    AccountCircle,
    ShoppingCart,
    Restaurant,
    Home,
    ListAlt,
    Person,
    Login,
    Logout,
    AdminPanelSettings,
} from '@mui/icons-material';
import { Link as RouterLink, useNavigate } from 'react-router-dom';
import { selectCartItemsCount } from '../store/cart/cartSlice';
import { logoutUser } from '../store/auth/authActions';
import { useDispatch } from 'react-redux';

const MainLayout = () => {
    const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
    const user = useSelector(state => state.auth.user);
    const cartItemsCount = useSelector(selectCartItemsCount);
    const dispatch = useDispatch();
    const navigate = useNavigate();

    const [anchorEl, setAnchorEl] = useState(null);
    const [drawerOpen, setDrawerOpen] = useState(false);

    // Check if user has admin or staff role
    const isAdminOrStaff = user && user.roles &&
        (user.roles.includes('ROLE_MENSA_ADMIN') || user.roles.includes('ROLE_STAFF'));

    const handleProfileMenuOpen = (event) => {
        setAnchorEl(event.currentTarget);
    };

    const handleMenuClose = () => {
        setAnchorEl(null);
    };

    const handleDrawerToggle = () => {
        setDrawerOpen(!drawerOpen);
    };

    const handleLogout = () => {
        dispatch(logoutUser());
        handleMenuClose();
        navigate('/');
    };

    const handleCartClick = () => {
        if (isLoggedIn) {
            navigate('/checkout');
        } else {
            navigate('/login', { state: { from: '/checkout' } });
        }
    };

    const navItems = [
        { text: 'Startseite', icon: <Home />, path: '/' },
        { text: 'Menüplan', icon: <Restaurant />, path: '/menu' },
    ];

    const authItems = isLoggedIn
        ? [
            { text: 'Meine Bestellungen', icon: <ListAlt />, path: '/orders' },
            { text: 'Mein Profil', icon: <Person />, path: '/profile' },
            ...(isAdminOrStaff ? [{ text: 'Admin-Bereich', icon: <AdminPanelSettings />, path: '/admin' }] : []),
        ]
        : [
            { text: 'Anmelden', icon: <Login />, path: '/login' },
            { text: 'Registrieren', icon: <AccountCircle />, path: '/register' },
        ];

    const drawer = (
        <Box sx={{ width: 250 }} role="presentation" onClick={handleDrawerToggle}>
            <List>
                {navItems.map((item) => (
                    <ListItem button key={item.text} component={RouterLink} to={item.path}>
                        <ListItemIcon>{item.icon}</ListItemIcon>
                        <ListItemText primary={item.text} />
                    </ListItem>
                ))}
            </List>
            <Divider />
            <List>
                {authItems.map((item) => (
                    <ListItem button key={item.text} component={RouterLink} to={item.path}>
                        <ListItemIcon>{item.icon}</ListItemIcon>
                        <ListItemText primary={item.text} />
                    </ListItem>
                ))}
                {isLoggedIn && (
                    <ListItem button onClick={handleLogout}>
                        <ListItemIcon><Logout /></ListItemIcon>
                        <ListItemText primary="Abmelden" />
                    </ListItem>
                )}
            </List>
        </Box>
    );

    return (
        <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
            <AppBar position="static">
                <Toolbar>
                    <IconButton
                        size="large"
                        edge="start"
                        color="inherit"
                        aria-label="menu"
                        sx={{ mr: 2 }}
                        onClick={handleDrawerToggle}
                    >
                        <MenuIcon />
                    </IconButton>
                    <Typography
                        variant="h6"
                        component={RouterLink}
                        to="/"
                        sx={{
                            flexGrow: 1,
                            textDecoration: 'none',
                            color: 'inherit',
                            display: { xs: 'none', sm: 'block' }
                        }}
                    >
                        Mensa App
                    </Typography>

                    <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
                        {navItems.map((item) => (
                            <Button
                                key={item.text}
                                component={RouterLink}
                                to={item.path}
                                sx={{ color: 'white', mx: 1 }}
                            >
                                {item.text}
                            </Button>
                        ))}
                    </Box>

                    <IconButton
                        size="large"
                        color="inherit"
                        onClick={handleCartClick}
                        sx={{ ml: 1 }}
                    >
                        <Badge badgeContent={cartItemsCount} color="error">
                            <ShoppingCart />
                        </Badge>
                    </IconButton>

                    {isLoggedIn ? (
                        <>
                            <IconButton
                                size="large"
                                edge="end"
                                aria-label="account of current user"
                                aria-haspopup="true"
                                onClick={handleProfileMenuOpen}
                                color="inherit"
                                sx={{ ml: 1 }}
                            >
                                <Avatar sx={{ width: 32, height: 32, bgcolor: 'secondary.main' }}>
                                    {user.vorname ? user.vorname[0] : 'U'}
                                </Avatar>
                            </IconButton>
                            <Menu
                                anchorEl={anchorEl}
                                anchorOrigin={{
                                    vertical: 'bottom',
                                    horizontal: 'right',
                                }}
                                keepMounted
                                transformOrigin={{
                                    vertical: 'top',
                                    horizontal: 'right',
                                }}
                                open={Boolean(anchorEl)}
                                onClose={handleMenuClose}
                            >
                                <MenuItem component={RouterLink} to="/profile" onClick={handleMenuClose}>
                                    Mein Profil
                                </MenuItem>
                                <MenuItem component={RouterLink} to="/orders" onClick={handleMenuClose}>
                                    Meine Bestellungen
                                </MenuItem>
                                {isAdminOrStaff && (
                                    <MenuItem component={RouterLink} to="/admin" onClick={handleMenuClose}>
                                        Admin-Bereich
                                    </MenuItem>
                                )}
                                <MenuItem onClick={handleLogout}>Abmelden</MenuItem>
                            </Menu>
                        </>
                    ) : (
                        <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
                            <Button
                                component={RouterLink}
                                to="/login"
                                color="inherit"
                                sx={{ ml: 1 }}
                            >
                                Anmelden
                            </Button>
                            <Button
                                component={RouterLink}
                                to="/register"
                                color="inherit"
                                variant="outlined"
                                sx={{ ml: 1 }}
                            >
                                Registrieren
                            </Button>
                        </Box>
                    )}
                </Toolbar>
            </AppBar>

            <Drawer
                anchor="left"
                open={drawerOpen}
                onClose={handleDrawerToggle}
            >
                {drawer}
            </Drawer>

            <Container component="main" sx={{ mt: 4, mb: 4, flexGrow: 1 }}>
                <Outlet />
            </Container>

            <Box
                component="footer"
                sx={{
                    py: 3,
                    px: 2,
                    mt: 'auto',
                    backgroundColor: (theme) => theme.palette.grey[200],
                }}
            >
                <Container maxWidth="lg">
                    <Typography variant="body2" color="text.secondary" align="center">
                        © {new Date().getFullYear()} Mensa App. Alle Rechte vorbehalten.
                    </Typography>
                </Container>
            </Box>
        </Box>
    );
};

export default MainLayout;