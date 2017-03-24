import type { Store as ReduxStore, Dispatch as ReduxDispatch } from 'redux';

export type Id = number;
export type Text = string;

export type Neighborhood {
  +id: Id,
  +name: Text,
  +coordinates: array
}

export type Coordinate = {
  +type: string,
  +path: array
}

export type State = {
  +neighborhood:  Neighborhood,
  +dataSets: Array
}

export type Action =
  {type: 'SWITCH_NEIGHBORHOOD', +id: ID, +text: Text}

export type Store = ReduxStore<State, Action>;

export type Dispatch = ReduxDispatch<Action>
