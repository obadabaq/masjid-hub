# How do neumorphic shadows work in Masjidhub app

There are two kinds of shadows in components of Masjidhub app, outer shadows and inner Shadows

## Outer shadows

- Outer shadows are easier to understand and use, have a look at `shadows.dart`
- `shadowNeu` in boxShadow below is taken from `shadows.dart`

```
 Container(
    decoration: BoxDecoration(
        color: CustomTheme.lightTheme.colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadowNeu,
    ),
 )
```

## Inner shadows

- There is no easy way to generate innerShadows for neumorphic flutter app because there is no built in method, so we had to create our own utility, `concaveDecoration.dart`
- Concave decoration is used like this exmaple below

```
Container(
  decoration: ConcaveDecoration(
                depth: 9,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                colors: innerConcaveShadow,
                size: Size(width, height
              ),
),
```
