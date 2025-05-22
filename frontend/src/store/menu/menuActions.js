import { toast } from 'react-toastify';
import { menuService } from '../../services/api';
import {
  fetchMenuStart,
  fetchMenuSuccess,
  fetchWeeklyMenusSuccess,
  fetchDishesSuccess,
  fetchMenuError,
  setSelectedDate,
} from './menuSlice';

// Fetch Today's Menu
export const fetchTodayMenu = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuToday();
    dispatch(fetchMenuSuccess(response.data));
    dispatch(setSelectedDate(response.data.datum));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden des Menüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Menu by Date
export const fetchMenuByDate = (date) => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuByDate(date);
    dispatch(fetchMenuSuccess(response.data));
    dispatch(setSelectedDate(date));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden des Menüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Weekly Menu
export const fetchWeeklyMenu = (startDate) => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuForWeek(startDate);
    dispatch(fetchWeeklyMenusSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der Wochenmenüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch All Dishes
export const fetchAllDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getAllDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Vegetarian Dishes
export const fetchVegetarianDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getVegetarianDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der vegetarischen Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Vegan Dishes
export const fetchVeganDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getVeganDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der veganen Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};
