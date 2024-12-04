import { Astal, ConstructProps } from "../gtk4"
import astalify, { BindableChild } from "./astalify"
import GObject from "gi://GObject"

// Box
export type BoxProps = ConstructProps<Box, Astal.Box.ConstructorProps>
export class Box extends astalify(
  Astal.Box, 
  Astal.Box.name
  // (children, self) => {
  //   self.set_children(children)
  // }
) {
    static { GObject.registerClass({ GTypeName: "Box" }, this) }
    constructor(props?: BoxProps, ...children: Array<BindableChild>) { super({ children, ...props } as any) }
}

// Button
export type ButtonProps = ConstructProps<Button, Astal.Button.ConstructorProps, {
    onClicked: []
    onClick: [event: Astal.ClickEvent]
    onClickRelease: [event: Astal.ClickEvent]
    onHover: [event: Astal.HoverEvent]
    onHoverLost: [event: Astal.HoverEvent]
    onScroll: [event: Astal.ScrollEvent]
}>
export class Button extends astalify(Astal.Button, Astal.Button.name) {
    static { GObject.registerClass({ GTypeName: "Button" }, this) }
    constructor(props?: ButtonProps, child?: BindableChild) { super({ child, ...props } as any) }
}

// CenterBox
export type CenterBoxProps = ConstructProps<CenterBox, Astal.CenterBox.ConstructorProps>
export class CenterBox extends astalify(
  Astal.CenterBox, 
  Astal.CenterBox.name, 
  (children, self) => {
    if (children.length > 3) {
        console.error(`CenterBoxes can have only 3 children, attempted to set ${children.length}`)
        return
    }
  }
) {
    static { GObject.registerClass({ GTypeName: "CenterBox" }, this) }
    constructor(props?: CenterBoxProps, ...children: Array<BindableChild>) { super({ children, ...props } as any) }
}

// Label
export type LabelProps = ConstructProps<Label, Astal.Label.ConstructorProps>
export class Label extends astalify(Astal.Label, Astal.Label.name) {
    static { GObject.registerClass({ GTypeName: "Label" }, this) }
    constructor(props?: LabelProps) { super(props as any) }
}

// Switch
export type SwitchProps = ConstructProps<Switch, Gtk.Switch.ConstructorProps>
export class Switch extends astalify(Gtk.Switch, Gtk.Switch.name) {
    static { GObject.registerClass({ GTypeName: "Switch" }, this) }
    constructor(props?: SwitchProps) { super(props as any) }
}

// Window
export type WindowProps = ConstructProps<Window, Astal.Window.ConstructorProps>
export class Window extends astalify(
    Astal.Window,
    Astal.Window.name,
    (children, self) => {
        if (children.length != 1) {
            console.error(`Window can have only 1 child, attempted to set ${children.length}`)
            return
        }

        self.set_child(children[0])
    },
) {
    static { GObject.registerClass({ GTypeName: "Window" }, this) }
    constructor(props?: WindowProps, child?: BindableChild) { super({ child, ...props } as any) }
}
