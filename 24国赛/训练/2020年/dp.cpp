#include <iostream>
#include <vector>
#include <stack>
#include <string> 
#include <cmath>
#include <map>
using namespace std;

const double neg_inf=-INFINITY;
const int water_weight=3,water_price=5,food_weight=2,food_price=10;
const int weightup=1200;
const int initial_money=10000;
const int base_income=1000;
const int i_max=30;
const int j_max=27;
const int k_max=weightup/water_weight;
const int l_max=weightup/food_weight;
int water_cost[3]={
	5,8,10
};
int food_cost[3]={
	7,6,10
}; 
map<short, short> mapping;
short GT[j_max][j_max]={
	{1,24},{0,2},{1,3,24},{2,24,4,23},{3,23,5},{4,23,22,6},
	{5.7,21},{6,21,8},{7,21,1,20,9,14,15},{8,12,10,11},{9,11,12},
	{10,12,13},{9,10,11,13,14},{11,12,14,15},{9,12,13,15,8},{8,12,13,16,16},
	{8,15,17,20},{
		16,15,18,19
	},{17,19},{17,18,20},{8,16,19,21,22,26},
	{6,7,8,20,22},{5,21,20,1,25},{3,4,5,22,24,25},{0,2,3,23,25},
	{24,23,22,26},{20,22,25}
};
short weather[i_max]={
	1,1,0,2,0,1,2,0,1,1,2,1,0,1,1,1,2,2,1,1,0,0,1,0,2,1,0,0,1,1
};
struct state{
	short i,j,k,l;
	state(int ii=-1,int jj=-1,int kk=-1,int ll=-1):i(ii),j(jj),k(kk),l(ll){	
	}
	bool operator !=(const state &st2){
		return i!=st2.i || j!=st2.j|| k!=st2.k|| l!=st2.l;
	}
};
vector<string>info(i_max,"沙漠");
int dp[i_max+1][j_max+1][k_max+1][l_max+1];
//state dp_state[i_max+1][j_max+1][k_max+1][l_max+1];
vector<short> G[j_max];
void init(){
	info[15]="村庄";
	info[11]="矿山"; 
	for(int i=0;i<j_max;i++){
		for(int j=0;j<j_max && GT[i][j];j++){
			G[i].push_back(GT[i][j]);
		}
	}
	mapping[0]=1;mapping[1]=25;mapping[3]=24;mapping[4]=23;mapping[5]=22;mapping[6]=9,mapping[7]=15;
	mapping[8]=14;mapping[9]=12;mapping[10]=25;mapping[11]=27;
	
	for(int i=0;i<i_max+1;i++){
		for(int j=0;j<j_max+1;j++){
			for(int k=0;k<k_max+1;k++){
				for(int l=0;l<l_max+1;l++){
					dp[i][j][k][l]=neg_inf;
				} 
			} 
		}
	}
	//起点购买物品 
	dp[0][0][0][0]=initial_money;
	for(int k=0;k<k_max;k++){
		int money_left=dp[0][0][0][0]-k*water_price;
		if(money_left<0){
			break;
		}
		for(int l=0;k*water_weight+l*food_weight<weightup;l++){
			money_left=dp[0][0][0][0]-k*water_price-l*food_price; 
			if(money_left<0){
				break;
			}	
			dp[0][0][k][l]=money_left;
			//dp_state[0][0][k][l]=state(0,0,0,0);
		}
	}
	for(int i=0;i<j_max;i++){
		for(int j=0;j<G[i].size();j++){
			cout<<G[i][j]<<' ';
		}
		cout<<endl;
	}
}
void buy(int i,int j,int k,int l){
	int k_max=weightup/water_weight;
	int l_max=weightup/food_weight;
	for(int kk=k;kk<k_max;kk++){
		int money_left=dp[i][j][k][l]-(kk-k)*water_price;
		if(money_left<=0){
			break;
		}
		for(int ll=l;ll<l_max;ll++){
			if(k==kk&&ll==l) continue;
			money_left=dp[i][j][k][l]-(kk-k)*water_price*2-(ll-l)*food_price*2;
			if(money_left<0 || money_left<=dp[i][j][k][l]){
				l_max=ll;
				break;
			}
			dp[i][j][kk][ll]=money_left;
			//dp_state[i][j][kk][ll]=state(i,k,kk,ll);
		}
	}
}
int main(){
	cout<<"初始化开始"<<endl; 
	init(); 
	cout<<"初始化结束"<<endl; 
	double best_ever=neg_inf;
	for(int i=0;i<i_max;i++){
		for(int j=0;j<j_max;j++){
			if(info[j]=="村庄"){
				for(int k=0;k<k_max;k++){
					for(int l=0;k*water_weight+l*food_weight<=weightup;l++){
						if(dp[i][j][k][l]>=0) buy(i,j,k,l);
						//cout<<"村庄购物"<<endl; 
					}
				}
			}
			//是否停留
			int water_comsumption=water_cost[weather[i]],food_consumption=food_cost[weather[i]];
			for(int k=water_comsumption;k<k_max;k++){
				for(int l=food_consumption;k*water_weight+l*food_weight<=weightup;l++){
					int water_left=k-water_comsumption;
					int food_left=l-food_consumption;
					if(dp[i][j][k][l]>0 && dp[i+1][j][water_left][food_left]<dp[i][j][k][l]){
						dp[i+1][j][water_left][food_left]=dp[i][j][k][l];
					//	dp_state[i+1][j][water_left][food_left]=state(i,j,k,l);
					}
				}
			}
			if(info[j]=="矿山"){
				int water_comsumption=3*water_cost[weather[i]],food_consumption=3*food_cost[weather[i]];
				for(int k=water_comsumption;k<k_max;k++){
					for(int l=food_consumption;k*water_weight+l*food_weight<=weightup;l++){
						int water_left=k-water_comsumption;
						int food_left=l-food_consumption;
						if(dp[i][j][k][l]>0 && dp[i+1][j][water_left][food_left]<dp[i][j][k][l]+base_income){
							dp[i+1][j][water_left][food_left]=dp[i][j][k][l]+base_income;
						//	dp_state[i+1][j][water_left][food_left]=state(i,j,k,l);
						}
					}
				}
			}
			//是否前进
			if(weather[i]!=2){
				for(int jj=0;jj<G[j].size();jj++){
					int water_comsumption=2*water_cost[weather[i]],food_consumption=2*food_cost[weather[i]];
					for(int k=water_comsumption;k<k_max;k++){
						for(int l=food_consumption	;k*water_weight+l*food_weight<=weightup;l++){
							int water_left=k-water_comsumption;
							int food_left=l-food_consumption;
							if(dp[i][j][k][l]>0 && dp[i+1][G[j][jj]][water_left][food_left]<dp[i][j][k][l]){
								dp[i+1][G[j][jj]][water_left][food_left]=dp[i][j][k][l];
						//		dp_state[i+1][G[j][jj]][water_left][food_left]=state(i,j,k,l);
								if(G[j][jj]==26) cout<< dp[i+1][G[j][jj]][water_left][food_left]<<endl;
							}
						}
					}
					//cout<<j<<' '<<G[j][jj]<<endl;
				}
			} 
			 
		}
		cout<<i<<endl;
		int target=j_max-1;
		double ref=neg_inf;//当天最大值 
		state last_state;
		for(int ii=0;ii<i_max;ii++){
			for(int k=0;k<k_max;k++){
				for(int l=0;k*water_weight+l*food_weight<=weightup;l++){
					if(dp[ii][target][k][l]>ref){
						ref=dp[ii][target][k][l];
						//last_state=state(ii,target,k,l); 
						cout<<dp[ii][target][k][l]<<' '<<ref<<endl; 
					}
				}
			}
		}
		
		if(ref>best_ever) {
			best_ever=ref;
	 		cout<<i+1<<"天最大值："<<best_ever<<endl;
			/*stack<state> sta;
			while(last_state != state(-1,-1,-1,-1)){
				sta.push(last_state);
				last_state=dp_state[last_state.i][last_state.j][last_state.k][last_state.l];
			} 
			while(!sta.empty()){
				last_state=sta.top();
				sta.pop();
				cout<<last_state.i<<' '<<last_state.j<<' '<<last_state.k<<' '<<last_state.l<<endl;
			}*/ 
			cout<<"**************************************************"<<endl;
		} 
		 
	}

	return 0; 
}