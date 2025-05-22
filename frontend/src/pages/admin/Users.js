import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import UserList from '../../components/admin/UserList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { userService } from '../../services/api';

const Users = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await userService.getAllUsers();
      setUsers(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Benutzer';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchUsers();
  }, []);
  
  const handleUpdateRoles = async (userId, roles) => {
    try {
      await userService.updateUserRoles(userId, roles);
      toast.success('Benutzerrollen erfolgreich aktualisiert');
      
      // Benutzer neu laden
      fetchUsers();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Aktualisieren der Benutzerrollen';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Benutzer werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchUsers} />;
  }
  
  return (
    <Box>
      <UserList 
        users={users} 
        onUpdateRoles={handleUpdateRoles}
      />
    </Box>
  );
};

export default Users;
