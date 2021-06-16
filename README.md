# homg_long

## Developer guild
1. info log는 Logger 사용
```python
final log = Logger("AppScreenCubit");
```

2. user info는 InAppUser를 사용
DBHelper.getUser()필요없음 app initialize 하면서 InAppUser에 미리 복사해둠.
```python
InAppUser _user = InAppUser();
````
