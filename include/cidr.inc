/***                                                    ***
 * CIDR Include - Check precise IP ranges		          *
 ***                                                    ***
 * @Author  Rafael 'R@f' Keramidas <rafael@keramid.as>    *
 * @Date    6th June 2013                                 *
 * @Version 1.0                                        	  *
 * @Licence MIT License                                   *
 *                                                        *
 * Copyright (C) 2013 Rafael Keramidas                    *
 *                                                        *
 * Permission is hereby granted, free of charge, to any   *
 * person obtaining a copy of this software and           *
 * associated documentation files (the "Software"), to    *
 * deal in the Software without restriction, including    *
 * without limitation the rights to use, copy, modify,    *
 * merge, publish, distribute, sublicense, and/or sell    *
 * copies of the Software, and to permit persons to whom  *
 * the Software is furnished to do so, subject to the     *
 * following conditions:                                  *
 *                                                        *
 * The above copyright notice and this permission notice  *
 * shall be included in all copies or substantial         *
 * portions of the Software.                              *
 *                                                        *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  *
 * ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT        *
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS  *
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO    *
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE *
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN  *
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE *
 * USE OR OTHER DEALINGS IN THE SOFTWARE.                 *
 ***                                                    ***/

#include <a_samp>

stock ip2long(const sIP[])
{
	new
		iCount = 0,
		iIPAddress = 0,
		iIPLenght = strlen(sIP);
		
	if(iIPLenght > 0 && iIPLenght < 17)
	{
	    for(new i = 0; i < iIPLenght; i++)
	        if(sIP[i] == '.')
	            iCount++;
	            
		if(iCount == 3)
		{
			iIPAddress = strval(sIP) << 24;
			iCount = strfind(sIP, ".", false, 0) + 1;
			iIPAddress += strval(sIP[iCount]) << 16;
			iCount = strfind(sIP, ".", false, iCount) + 1;
			iIPAddress += strval(sIP[iCount]) << 8;
			iCount = strfind(sIP, ".", false, iCount) + 1;
			iIPAddress += strval(sIP[iCount]);
		}
	}
	
	return iIPAddress;
}

stock cidr_match(sIP[], sRange[])
{
	new
		sRangeInfo[2][18],
		iIP = 0,
		iSubnet = 0,
		iBits = 0,
		iMask = 0;
		
	split(sRange, sRangeInfo, '/');
	iIP = ip2long(sIP);
	iSubnet = ip2long(sRangeInfo[0]);
	iBits = strval(sRangeInfo[1]);
	
	iMask = -1 << (32 - iBits);
	iSubnet &= iMask;
	
	return (iIP & iMask) == iSubnet;
}