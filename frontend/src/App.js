import React, { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { checkTokenExpiration } from './store/auth/authActions';

// Layouts
import MainLayout from './layouts/MainLayout';
import AdminLayout from './layouts/AdminLayout';

// Pages
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import Menu from './pages/Menu';
import MenuDetails from './pages/MenuDetails';
import Checkout from './pages/Checkout';
import Payment from './pages/Payment';
import OrderConfirmation from './pages/OrderConfirmation';
import Profile from './pages/Profile';
import OrderHistory from './pages/OrderHistory';
import OrderDetail from './pages/OrderDetail';
import AdminDashboard from './pages/admin/Dashboard';
import AdminOrders from './pages/admin/Orders';
import AdminMenus from './pages/admin/Menus';
import AdminMenuEdit from './pages/admin/MenuEdit';
import AdminDishes from './pages/admin/Dishes';
import AdminDishEdit from './pages/admin/DishEdit';
import AdminDrinks from './pages/admin/Drinks';
import AdminDrinkEdit from './pages/admin/DrinkEdit';
import AdminUsers from './pages/admin/Users';
import NotFound from './pages/NotFound';

// Protected Route Component
const ProtectedRoute = ({ children, allowedRoles }) => {
  const { isLoggedIn, user } = useSelector(state => state.auth);
  const dispatch = useDispatch();

  useEffect(() => {
    if (isLoggedIn) {
      dispatch(checkTokenExpiration());
    }
  }, [dispatch, isLoggedIn]);

  if (!isLoggedIn) {
    return <Navigate to="/login" />;
  }

  if (allowedRoles && (!user.roles || !allowedRoles.some(role => user.roles.includes(role)))) {
    return <Navigate to="/" />;
  }

  return children;
};

const App = () => {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/" element={<MainLayout />}>
        <Route index element={<Home />} />
        <Route path="login" element={<Login />} />
        <Route path="register" element={<Register />} />
        <Route path="menu" element={<Menu />} />
        <Route path="menu/:date" element={<MenuDetails />} />
        
        {/* Protected User Routes */}
        <Route path="checkout" element={
          <ProtectedRoute>
            <Checkout />
          </ProtectedRoute>
        } />
        <Route path="payment/:orderId" element={
          <ProtectedRoute>
            <Payment />
          </ProtectedRoute>
        } />
        <Route path="order-confirmation/:orderId" element={
          <ProtectedRoute>
            <OrderConfirmation />
          </ProtectedRoute>
        } />
        <Route path="profile" element={
          <ProtectedRoute>
            <Profile />
          </ProtectedRoute>
        } />
        <Route path="orders" element={
          <ProtectedRoute>
            <OrderHistory />
          </ProtectedRoute>
        } />
        <Route path="orders/:id" element={
          <ProtectedRoute>
            <OrderDetail />
          </ProtectedRoute>
        } />
      </Route>

      {/* Admin Routes */}
      <Route path="/admin" element={
        <ProtectedRoute allowedRoles={['ROLE_ADMIN', 'ROLE_STAFF']}>
          <AdminLayout />
        </ProtectedRoute>
      }>
        <Route index element={<AdminDashboard />} />
        <Route path="orders" element={<AdminOrders />} />
        <Route path="menus" element={<AdminMenus />} />
        <Route path="menus/new" element={<AdminMenuEdit />} />
        <Route path="menus/:id" element={<AdminMenuEdit />} />
        <Route path="dishes" element={<AdminDishes />} />
        <Route path="dishes/new" element={<AdminDishEdit />} />
        <Route path="dishes/:id" element={<AdminDishEdit />} />
        <Route path="drinks" element={<AdminDrinks />} />
        <Route path="drinks/new" element={<AdminDrinkEdit />} />
        <Route path="drinks/:id" element={<AdminDrinkEdit />} />
        <Route path="users" element={
          <ProtectedRoute allowedRoles={['ROLE_ADMIN']}>
            <AdminUsers />
          </ProtectedRoute>
        } />
      </Route>
      
      {/* Not Found */}
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

export default App;
