import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  Box,
  Typography,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  InputAdornment,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Button,
} from '@mui/material';
import {
  Edit as EditIcon,
  Security as SecurityIcon,
  Search as SearchIcon,
  Save as SaveIcon,
} from '@mui/icons-material';

const UserList = ({ users, onUpdateRoles }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [roleDialogOpen, setRoleDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedRoles, setSelectedRoles] = useState([]);
  
  const handleOpenRoleDialog = (user) => {
    setSelectedUser(user);
    setSelectedRoles(user.roles.map(role => role.replace('ROLE_', '')));
    setRoleDialogOpen(true);
  };
  
  const handleCloseRoleDialog = () => {
    setRoleDialogOpen(false);
    setSelectedUser(null);
  };
  
  const handleRoleChange = (event) => {
    setSelectedRoles(event.target.value);
  };
  
  const handleSaveRoles = () => {
    if (selectedUser) {
      onUpdateRoles(selectedUser.id, selectedRoles);
    }
    handleCloseRoleDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const filteredUsers = users.filter(user => {
    return user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
           user.vorname.toLowerCase().includes(searchTerm.toLowerCase()) ||
           user.nachname.toLowerCase().includes(searchTerm.toLowerCase());
  });
  
  const getRoleChip = (role) => {
    let color = 'default';
    let label = role.replace('ROLE_', '');
    
    switch (role) {
      case 'ROLE_MENSA_ADMIN':
        color = 'error';
        break;
      case 'ROLE_STAFF':
        color = 'primary';
        break;
      case 'ROLE_USER':
        color = 'success';
        break;
      default:
        color = 'default';
    }
    
    return <Chip label={label} color={color} size="small" sx={{ mr: 0.5 }} />;
  };
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Benutzer verwalten
        </Typography>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Benutzer suchen..."
          variant="outlined"
          size="small"
          value={searchTerm}
          onChange={handleSearchChange}
          sx={{ width: '40%' }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>E-Mail</TableCell>
              <TableCell>Rollen</TableCell>
              <TableCell>MFA</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredUsers.length > 0 ? (
              filteredUsers.map((user) => (
                <TableRow key={user.id}>
                  <TableCell>{user.id}</TableCell>
                  <TableCell>{`${user.vorname} ${user.nachname}`}</TableCell>
                  <TableCell>{user.email}</TableCell>
                  <TableCell>
                    {user.roles.map(role => (
                      <span key={role}>
                        {getRoleChip(role)}
                      </span>
                    ))}
                  </TableCell>
                  <TableCell>
                    {user.mfaEnabled ? 
                      <Chip label="Aktiviert" size="small" color="success" /> : 
                      <Chip label="Deaktiviert" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleOpenRoleDialog(user)}
                      title="Rollen bearbeiten"
                    >
                      <SecurityIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Benutzer gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={roleDialogOpen}
        onClose={handleCloseRoleDialog}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>Benutzerrollen bearbeiten</DialogTitle>
        <DialogContent>
          {selectedUser && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" gutterBottom>
                Benutzer: {selectedUser.vorname} {selectedUser.nachname}
              </Typography>
              <Typography variant="body2" color="text.secondary" gutterBottom>
                E-Mail: {selectedUser.email}
              </Typography>
              
              <FormControl fullWidth sx={{ mt: 2 }}>
                <InputLabel id="roles-label">Rollen</InputLabel>
                <Select
                  labelId="roles-label"
                  id="roles"
                  multiple
                  value={selectedRoles}
                  onChange={handleRoleChange}
                  renderValue={(selected) => (
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                      {selected.map((value) => (
                        <Chip key={value} label={value} />
                      ))}
                    </Box>
                  )}
                >
                  <MenuItem value="USER">Benutzer</MenuItem>
                  <MenuItem value="STAFF">Mitarbeiter</MenuItem>
                  <MenuItem value="MENSA_ADMIN">Administrator</MenuItem>
                </Select>
              </FormControl>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseRoleDialog}>Abbrechen</Button>
          <Button
            onClick={handleSaveRoles}
            variant="contained"
            color="primary"
            startIcon={<SaveIcon />}
          >
            Speichern
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default UserList;
