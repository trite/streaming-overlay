export type Mutable<T> = {
  -readonly [k in keyof T]: T[k];
};

export type Immutable<T> = {
  +readonly [k in keyof T]: T[k];
};

export default function fromReadonly<T>(obj: T): T {
  return obj as Mutable<T>;
}
