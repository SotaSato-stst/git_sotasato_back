export type Validate = (result: (valid: boolean) => void) => void

export type ValidationForm = {
  validate: (result: (valid: boolean) => void) => void
}
