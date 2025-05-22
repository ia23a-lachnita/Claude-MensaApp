import axios from 'axios';
import { store } from '../store';
import { logout } from '../store/auth/authSlice';

const API_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor für Anfragen
api.interceptors.request.use(
  (config) => {
    const { auth } = store.getState();
    if (auth.token) {
      config.headers.Authorization = `Bearer ${auth.token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor für Antworten
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;
    
    // Bei 401 Unauthorized automatisch abmelden
    if (response && response.status === 401) {
      store.dispatch(logout());
    }
    
    return Promise.reject(error);
  }
);

// Auth Services
export const authService = {
  login: (email, password) => api.post('/auth/signin', { email, password }),
  register: (userData) => api.post('/auth/signup', userData),
  verifyMfa: (email, password, code) => api.post('/auth/mfa-verify', { email, password, code }),
  setupMfa: (email) => api.post('/auth/mfa-setup', { email }),
  enableMfa: (email, code) => api.post('/auth/mfa-enable', { email, code }),
  disableMfa: (email, code) => api.post('/auth/mfa-disable', { email, code }),
};

// User Services
export const userService = {
  getCurrentUser: () => api.get('/users/me'),
  updateProfile: (userData) => api.put('/users/me', userData),
  updatePassword: (passwordData) => api.put('/users/me/password', passwordData),
  getAllUsers: () => api.get('/users'),
  getUserById: (id) => api.get(`/users/${id}`),
  updateUserRoles: (id, roles) => api.put(`/users/${id}/roles`, roles),
};

// Menu Services
export const menuService = {
  getMenuToday: () => api.get('/menu/heute'),
  getMenuByDate: (date) => api.get(`/menu/datum/${date}`),
  getMenuForWeek: (startDate) => api.get('/menu/woche', { params: { startDatum: startDate } }),
  getAllDishes: () => api.get('/menu/gerichte'),
  getVegetarianDishes: () => api.get('/menu/gerichte/vegetarisch'),
  getVeganDishes: () => api.get('/menu/gerichte/vegan'),
};

// Menuplan Admin Services
export const menuplanService = {
  getAllMenuplans: () => api.get('/menuplan'),
  getMenuplanById: (id) => api.get(`/menuplan/${id}`),
  getMenuplanByDate: (date) => api.get(`/menuplan/datum/${date}`),
  createMenuplan: (menuplanData) => api.post('/menuplan', menuplanData),
  updateMenuplan: (id, menuplanData) => api.put(`/menuplan/${id}`, menuplanData),
  deleteMenuplan: (id) => api.delete(`/menuplan/${id}`),
};

// Gericht Services
export const gerichtService = {
  getAllGerichte: () => api.get('/gerichte'),
  getGerichtById: (id) => api.get(`/gerichte/${id}`),
  createGericht: (gerichtData) => api.post('/gerichte', gerichtData),
  updateGericht: (id, gerichtData) => api.put(`/gerichte/${id}`, gerichtData),
  deleteGericht: (id) => api.delete(`/gerichte/${id}`),
};

// Bestellung Services
export const bestellungService = {
  getMyBestellungen: () => api.get('/bestellungen/meine'),
  getBestellungById: (id) => api.get(`/bestellungen/${id}`),
  createBestellung: (bestellungData) => api.post('/bestellungen', bestellungData),
  storniereBestellung: (id) => api.put(`/bestellungen/${id}/stornieren`),
  getAllBestellungen: () => api.get('/bestellungen/alle'),
  getBestellungenByDatum: (date) => api.get(`/bestellungen/datum/${date}`),
  updateBestellungStatus: (id, status) => api.put(`/bestellungen/${id}/status`, null, { params: { status } }),
};

// Getränk Services
export const getraenkService = {
  getAllGetraenke: () => api.get('/getraenke'),
  getGetraenkById: (id) => api.get(`/getraenke/${id}`),
  getVerfuegbareGetraenke: () => api.get('/getraenke/verfuegbar'),
  createGetraenk: (getraenkData) => api.post('/getraenke', getraenkData),
  updateGetraenk: (id, getraenkData) => api.put(`/getraenke/${id}`, getraenkData),
  updateVorrat: (id, vorrat) => api.put(`/getraenke/${id}/vorrat`, null, { params: { vorrat } }),
  deleteGetraenk: (id) => api.delete(`/getraenke/${id}`),
};

// Zahlung Services
export const zahlungService = {
  processZahlung: (bestellungId, zahlungData) => api.post(`/zahlungen/${bestellungId}`, zahlungData),
  getZahlungStatus: (bestellungId) => api.get(`/zahlungen/${bestellungId}`),
};

export default api;
