



for (int i = i_cur; i < 2; ++i)
	for (int j = j_cur; j < 2; ++j)








void replace(bool x, bool y)
{
	bool tmp = x;
	x = y;
	y = tmp;
}

void replace_arr(bool source_table, char course)
{

	switch (course)
	{
		case 'l':
			replace_l(i_cur, j_cur);
			_wait_ms();
			break;
		case 'r':
			replace_r(i_cur, j_cur);
			_wait_ms();
			break;
		case 'u':
			replace_u(i_cur, j_cur);
			_wait_ms();
			break;
		case 'd':
			replace_d1(i_cur, j_cur);
			_wait_ms();
			break;
	}
}


void replace_l(int i_cur, int j_cur)
{
	for (char j = j_cur + 1; j > (j_cur - 1); --j)
		for (char i = (i_cur); i < (i_cur + 2); ++i)
			replace(source_table[j][i], source_table[j+2][i]);
}

void replace_r(int i_cur, int j_cur)
{
	for (char j = j_cur - 2; j < (j_cur); ++j)
		for (char i = (i_cur + 1); i < (i_cur + 1); ++i)
			replace(source_table[j][i], source_table[j+2][i]);
}

void replace_u(int i_cur, int j_cur)
{
	for (char i = i_cur + 1; i > (i_cur - 1); --i)
		for (char j = j_cur; j < (j_cur + 2); ++j)
			replace(source_table[j][i], source_table[j][i+2]);
}

void replace_d(int i_cur, int j_cur)
{
	for (char i = i_cur; i > (i_cur + 2); ++i)
		for (char j = j_cur; j < (j_cur + 2); ++j)
			replace(source_table[j][i], source_table[j][i-2]);
}








