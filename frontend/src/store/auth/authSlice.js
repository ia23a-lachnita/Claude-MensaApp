import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  isLoggedIn: false,
  user: null,
  token: null,
  error: null,
  loading: false,
  mfaRequired: false,
  mfaEmail: null,
  mfaPassword: null,
};

export const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    loginStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    loginSuccess: (state, action) => {
      state.isLoggedIn = true;
      state.user = {
        id: action.payload.id,
        email: action.payload.email,
        vorname: action.payload.vorname,
        nachname: action.payload.nachname,
        roles: action.payload.roles,
      };
      state.token = action.payload.token;
      state.loading = false;
      state.error = null;
      state.mfaRequired = false;
      state.mfaEmail = null;
      state.mfaPassword = null;
    },
    loginError: (state, action) => {
      state.isLoggedIn = false;
      state.user = null;
      state.token = null;
      state.loading = false;
      state.error = action.payload;
      state.mfaRequired = false;
    },
    logout: (state) => {
      state.isLoggedIn = false;
      state.user = null;
      state.token = null;
      state.error = null;
      state.loading = false;
      state.mfaRequired = false;
      state.mfaEmail = null;
      state.mfaPassword = null;
    },
    registerStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    registerSuccess: (state) => {
      state.loading = false;
      state.error = null;
    },
    registerError: (state, action) => {
      state.loading = false;
      state.error = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
    requireMfa: (state, action) => {
      state.mfaRequired = true;
      state.mfaEmail = action.payload.email;
      state.mfaPassword = action.payload.password;
      state.loading = false;
    },
    updateUser: (state, action) => {
      state.user = {
        ...state.user,
        ...action.payload,
      };
    },
  },
});

export const {
  loginStart,
  loginSuccess,
  loginError,
  logout,
  registerStart,
  registerSuccess,
  registerError,
  clearError,
  requireMfa,
  updateUser,
} = authSlice.actions;

export default authSlice.reducer;
