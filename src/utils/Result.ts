// Result wrapper around FP-TS Either

import * as E from 'fp-ts/Either';

export type Result<T> = E.Either<Error, T>;

export const match =
  <T, R>(ok: (result: T) => R, err: (error: Error) => R) =>
  (result: Result<T>): R =>
    E.fold(err, ok)(result);

export function Err<T>(error: Error): Result<T> {
  return E.left(error);
}

export function Ok<T>(result: T): Result<T> {
  return E.right(result);
}
