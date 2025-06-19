import { toast } from 'react-toastify';
import { jwtDecode } from 'jwt-decode';
import { authService, userService } from '../../services/api';
import {
  loginStart,
  loginSuccess,
  loginError,
  logout,
  registerStart,
  registerSuccess,
  registerError,
  requireMfa,
  updateUser,
} from './authSlice';

// Login Action
export const login = (email, password) => async (dispatch) => {
  dispatch(loginStart());
  try {
    const response = await authService.login(email, password);
    if (response.data.mfaRequired) {
      dispatch(requireMfa({ email, password }));
    } else {
      dispatch(loginSuccess(response.data));
      toast.success('Erfolgreich angemeldet!');
    }
  } catch (error) {
    let message = 'Anmeldung fehlgeschlagen';

    // Spezielle Behandlung für verschiedene HTTP Status Codes
    if (error.response?.status === 423) { // Account gesperrt
      message = 'Account ist gesperrt. Bitte versuchen Sie es in 10 Minuten erneut.';
    } else if (error.response?.status === 401) { // Ungültige Credentials
      message = 'Ungültige E-Mail oder Passwort';
    } else if (error.response?.data?.message) {
      message = error.response.data.message;
    }

    dispatch(loginError(message));
    // toast.error wird im LoginForm.js behandelt, nicht hier
  }
};

// Verify MFA Code Action
export const verifyMfa = (email, password, code) => async (dispatch) => {
  dispatch(loginStart());
  try {
    const response = await authService.verifyMfa(email, password, code);
    dispatch(loginSuccess(response.data));
    toast.success('Erfolgreich angemeldet!');
  } catch (error) {
    const message = error.response?.data?.message || 'MFA-Verifizierung fehlgeschlagen';
    dispatch(loginError(message));
    toast.error(message);
  }
};

// Register Action
export const register = (userData) => async (dispatch) => {
  dispatch(registerStart());
  try {
    const response = await authService.register(userData);
    dispatch(registerSuccess());
    toast.success(response.data.message || 'Registrierung erfolgreich. Bitte melden Sie sich an.');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Registrierung fehlgeschlagen';
    dispatch(registerError(message));
    toast.error(message);
    return false;
  }
};

// Logout Action
export const logoutUser = () => (dispatch) => {
  dispatch(logout());
  toast.info('Sie wurden abgemeldet');
};

// Check Token Expiration
export const checkTokenExpiration = () => (dispatch, getState) => {
  const { token } = getState().auth;
  if (token) {
    try {
      const decodedToken = jwtDecode(token);
      const currentTime = Date.now() / 1000;

      if (decodedToken.exp < currentTime) {
        dispatch(logout());
        toast.info('Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.');
      }
    } catch (error) {
      dispatch(logout());
    }
  }
};

// Update Profile
export const updateProfile = (userData) => async (dispatch) => {
  try {
    const response = await userService.updateProfile(userData);
    dispatch(updateUser(response.data));
    toast.success('Profil erfolgreich aktualisiert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Profils';
    toast.error(message);
    return false;
  }
};

// Update Password
export const updatePassword = (passwordData) => async (dispatch) => {
  try {
    await userService.updatePassword(passwordData);
    toast.success('Passwort erfolgreich aktualisiert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Passworts';
    toast.error(message);
    return false;
  }
};

// Setup MFA
export const setupMfa = (email) => async () => {
  try {
    // This will send: { "email": "user@example.com" }
    const response = await authService.setupMfa(email);
    return response.data;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Einrichten der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    throw error;
  }
};

// Enable MFA
export const enableMfa = (email, code) => async (dispatch) => {
  try {
    // This will send: { "email": "user@example.com", "code": "123456" }
    await authService.enableMfa(email, code);
    dispatch(updateUser({ mfaEnabled: true }));
    toast.success('Zwei-Faktor-Authentifizierung erfolgreich aktiviert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktivieren der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    return false;
  }
};

// Disable MFA
export const disableMfa = (email, code) => async (dispatch) => {
  try {
    // This will send: { "email": "user@example.com", "code": "123456" }
    await authService.disableMfa(email, code);
    dispatch(updateUser({ mfaEnabled: false }));
    toast.success('Zwei-Faktor-Authentifizierung erfolgreich deaktiviert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Deaktivieren der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    return false;
  }
};
